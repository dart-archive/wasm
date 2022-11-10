// Copyright (c) 2020, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:ffi';
import 'dart:typed_data';

import 'package:ffi/ffi.dart';

import 'errors.dart';
import 'runtime.dart';
import 'wasmer_api.dart';

/// Creates a new wasm module asynchronously.
Future<WasmModule> wasmModuleCompileAsync(
  Uint8List data,
) async {
  return wasmModuleCompileSync(data);
}

/// Creates a new wasm module synchronously.
WasmModule wasmModuleCompileSync(
  Uint8List data,
) {
  return WasmModule._(data);
}

/// A compiled module that can be instantiated.
class WasmModule {
  late final Pointer<WasmerModule> _module;

  /// Compile a module.
  WasmModule._(Uint8List data) {
    _module = runtime.compile(this, data);
  }

  /// Returns a [WasmInstanceBuilder] that is used to add all the imports that
  /// the module needs before instantiating it.
  WasmInstanceBuilder builder() => WasmInstanceBuilder._(this);

  /// Create a new memory with the given number of initial pages, and optional
  /// maximum number of pages.
  WasmMemory createMemory(int pages, [int? maxPages]) =>
      WasmMemory._create(pages, maxPages);

  /// Returns a description of all of the module's imports and exports, for
  /// debugging.
  String describe() {
    final description = StringBuffer();
    final imports = runtime.importDescriptors(_module);
    for (final imp in imports) {
      description.write('import $imp\n');
    }
    final exports = runtime.exportDescriptors(_module);
    for (final exp in exports) {
      description.write('export $exp\n');
    }
    return description.toString();
  }
}

Pointer<WasmerTrap> _wasmFnImportTrampoline(
  Pointer<_WasmFnImport> imp,
  Pointer<WasmerValVec> args,
  Pointer<WasmerValVec> results,
) {
  try {
    _WasmFnImport._call(imp, args, results);
  } catch (exception) {
    return runtime.newTrap(exception);
  }
  return nullptr;
}

void _wasmFnImportFinalizer(Pointer<_WasmFnImport> imp) {
  _wasmFnImportToFn.remove(imp.address);
  calloc.free(imp);
}

final _wasmFnImportTrampolineNative = Pointer.fromFunction<
    Pointer<WasmerTrap> Function(
  Pointer<_WasmFnImport>,
  Pointer<WasmerValVec>,
  Pointer<WasmerValVec>,
)>(_wasmFnImportTrampoline);
final _wasmFnImportToFn = <int, Function>{};

// This will be needed again once #47 is fixed.
// ignore: unused_element
final _wasmFnImportFinalizerNative =
    Pointer.fromFunction<Void Function(Pointer<_WasmFnImport>)>(
  _wasmFnImportFinalizer,
);

class _WasmFnImport extends Struct {
  @Int32()
  external int returnType;

  static void _call(
    Pointer<_WasmFnImport> imp,
    Pointer<WasmerValVec> rawArgs,
    Pointer<WasmerValVec> rawResult,
  ) {
    final fn = _wasmFnImportToFn[imp.address] as Function;
    final args = [];
    for (var i = 0; i < rawArgs.ref.length; ++i) {
      args.add(rawArgs.ref.data[i].toDynamic);
    }
    assert(
      rawResult.ref.length == 1 || imp.ref.returnType == wasmerValKindVoid,
    );
    final result = Function.apply(fn, args);
    if (imp.ref.returnType != wasmerValKindVoid) {
      rawResult.ref.data[0].fill(imp.ref.returnType, result);
    }
  }
}

/// Used to collect all of the imports that a [WasmModule] requires before it is
/// built.
class WasmInstanceBuilder {
  final _importOwner = _WasmImportOwner();
  final _importIndex = <String, int>{};
  final _imports = calloc<WasmerExternVec>();
  final WasmModule _module;
  late final List<WasmImportDescriptor> _importDescs;
  Pointer<WasmerWasiEnv> _wasiEnv = nullptr;

  WasmInstanceBuilder._(this._module)
      : _importDescs = runtime.importDescriptors(_module._module) {
    _imports.ref.length = _importDescs.length;
    _imports.ref.data = calloc<Pointer<WasmerExtern>>(_importDescs.length);
    for (var i = 0; i < _importDescs.length; ++i) {
      final imp = _importDescs[i];
      _importIndex['${imp.moduleName}::${imp.name}'] = i;
      _imports.ref.data[i] = nullptr;
    }
  }

  int _getIndex(String moduleName, String name) {
    final index = _importIndex['$moduleName::$name'];
    if (index == null) {
      throw _WasmModuleErrorImpl('Import not found: $moduleName::$name');
    } else if (_imports.ref.data[index] != nullptr) {
      throw _WasmModuleErrorImpl('Import already filled: $moduleName::$name');
    } else {
      return index;
    }
  }

  /// Add a WasmMemory to the imports.
  void addMemory(
    String moduleName,
    String name,
    WasmMemory memory,
  ) {
    final index = _getIndex(moduleName, name);
    final imp = _importDescs[index];
    if (imp.kind != wasmerExternKindMemory) {
      throw _WasmModuleErrorImpl('Import is not a memory: $imp');
    }
    _imports.ref.data[index] = runtime.memoryToExtern(memory._mem);
  }

  /// Add a function to the imports.
  void addFunction(String moduleName, String name, Function fn) {
    final index = _getIndex(moduleName, name);
    final imp = _importDescs[index];

    if (imp.kind != wasmerExternKindFunction) {
      throw _WasmModuleErrorImpl('Import is not a function: $imp');
    }

    final funcType = imp.type as Pointer<WasmerFunctype>;
    final returnType = runtime.getReturnType(funcType);
    final wasmFnImport = calloc<_WasmFnImport>();
    wasmFnImport.ref.returnType = returnType;
    _wasmFnImportToFn[wasmFnImport.address] = fn;
    final fnImp = runtime.newFunc(
      _importOwner,
      funcType,
      _wasmFnImportTrampolineNative,
      wasmFnImport,
      nullptr, // TODO(#47): Re-enable _wasmFnImportFinalizerNative.
    );
    _imports.ref.data[index] = runtime.functionToExtern(fnImp);
  }

  /// Add a global to the imports.
  WasmGlobal addGlobal(String moduleName, String name, dynamic val) {
    final index = _getIndex(moduleName, name);
    final imp = _importDescs[index];

    if (imp.kind != wasmerExternKindGlobal) {
      throw _WasmModuleErrorImpl('Import is not a global: $imp');
    }

    final globalType = imp.type as Pointer<WasmerGlobaltype>;
    final global = runtime.newGlobal(_importOwner, globalType, val);
    _imports.ref.data[index] = runtime.globalToExtern(global);
    return WasmGlobal._('${imp.moduleName}::${imp.name}', global);
  }

  /// Enable WASI and add the default WASI imports.
  void enableWasi({
    bool captureStdout = false,
    bool captureStderr = false,
  }) {
    if (_wasiEnv != nullptr) {
      throw _WasmModuleErrorImpl('WASI is already enabled.');
    }
    final config = runtime.newWasiConfig();
    if (captureStdout) runtime.captureWasiStdout(config);
    if (captureStderr) runtime.captureWasiStderr(config);
    _wasiEnv = runtime.newWasiEnv(config);
    runtime.getWasiImports(_module._module, _wasiEnv, _imports);
  }

  /// Build the module instance.
  WasmInstance build() {
    for (var i = 0; i < _importDescs.length; ++i) {
      if (_imports.ref.data[i] == nullptr) {
        throw _WasmModuleErrorImpl('Missing import: ${_importDescs[i]}');
      }
    }
    return WasmInstance._(_module, _importOwner, _imports, _wasiEnv);
  }

  /// Asynchronously build the module instance.
  Future<WasmInstance> buildAsync() async => Future<WasmInstance>(build);
}

// TODO: should not be required once the min supported Dart SDK includes
//  github.com/dart-lang/sdk/commit/8fd81f72281d9d3aa5ef3890c947cc7305c56a50
class _WasmImportOwner {}

/// An instantiated [WasmModule].
///
/// Created by calling [WasmInstanceBuilder.build].
class WasmInstance {
  final _WasmImportOwner _importOwner;
  final _functions = <String, WasmFunction>{};
  final _globals = <String, WasmGlobal>{};
  final WasmModule _module;
  final Pointer<WasmerWasiEnv> _wasiEnv;

  late final Pointer<WasmerInstance> _instance;

  Pointer<WasmerMemory>? _exportedMemory;
  Stream<List<int>>? _stdout;
  Stream<List<int>>? _stderr;

  WasmInstance._(
    this._module,
    this._importOwner,
    Pointer<WasmerExternVec> imports,
    this._wasiEnv,
  ) {
    _instance = runtime.instantiate(
      _importOwner,
      _module._module,
      imports,
    );
    final exports = runtime.exports(_instance);
    final exportDescs = runtime.exportDescriptors(_module._module);
    assert(exports.ref.length == exportDescs.length);
    for (var i = 0; i < exports.ref.length; ++i) {
      final e = exports.ref.data[i];
      final kind = runtime.externKind(exports.ref.data[i]);
      final name = exportDescs[i].name;
      if (kind == wasmerExternKindFunction) {
        final f = runtime.externToFunction(e);
        final ft = exportDescs[i].type as Pointer<WasmerFunctype>;
        _functions[name] = WasmFunction._(
          name,
          f,
          runtime.getArgTypes(ft),
          runtime.getReturnType(ft),
        );
      } else if (kind == wasmerExternKindMemory) {
        // WASM currently allows only one memory per module.
        final mem = runtime.externToMemory(e);
        _exportedMemory = mem;
      } else if (kind == wasmerExternKindGlobal) {
        _globals[name] = WasmGlobal._(name, runtime.externToGlobal(e));
      }
    }
  }

  /// Searches the instantiated module for the given function.
  ///
  /// Returns a [WasmFunction], but the return type is [dynamic] to allow
  /// easy invocation as a [Function].
  ///
  /// Returns `null` if no function exists with name [name].
  dynamic lookupFunction(String name) => _functions[name];

  /// Searches the instantiated module for the given global.
  ///
  /// Returns `null` if no global exists with name [name].
  WasmGlobal? lookupGlobal(String name) => _globals[name];

  /// Returns the memory exported from this instance.
  WasmMemory get memory {
    if (_exportedMemory == null) {
      throw _WasmModuleErrorImpl('Wasm module did not export its memory.');
    }
    return WasmMemory._fromExport(_exportedMemory as Pointer<WasmerMemory>);
  }

  /// Returns a stream that reads from `stdout`.
  ///
  /// To use this, you must enable WASI when instantiating the module, and set
  /// `captureStdout` to `true`.
  Stream<List<int>> get stdout {
    if (_wasiEnv == nullptr) {
      throw _WasmModuleErrorImpl("Can't capture stdout without WASI enabled.");
    }
    return _stdout ??= runtime.getWasiStdoutStream(_wasiEnv);
  }

  /// Returns a stream that reads from `stderr`.
  ///
  /// To use this, you must enable WASI when instantiating the module, and set
  /// `captureStderr` to `true`.
  Stream<List<int>> get stderr {
    if (_wasiEnv == nullptr) {
      throw _WasmModuleErrorImpl("Can't capture stderr without WASI enabled.");
    }
    return _stderr ??= runtime.getWasiStderrStream(_wasiEnv);
  }
}

/// Memory of a [WasmInstance].
///
/// Access via [WasmInstance.memory] or create via [WasmModule.createMemory].
class WasmMemory {
  late final Pointer<WasmerMemory> _mem;
  late Uint8List _view;

  WasmMemory._fromExport(this._mem) {
    _view = runtime.memoryView(_mem);
  }

  WasmMemory._create(int pages, int? maxPages) {
    _mem = runtime.newMemory(this, pages, maxPages);
    _view = runtime.memoryView(_mem);
  }

  /// The WASM spec defines the page size as 64KiB.
  static const int kPageSizeInBytes = 64 * 1024;

  /// The length of the memory in pages.
  int get lengthInPages => runtime.memoryLength(_mem);

  /// The length of the memory in bytes.
  int get lengthInBytes => _view.lengthInBytes;

  /// The byte at the given [index].
  int operator [](int index) => _view[index];

  /// Sets the byte at the given index to value.
  void operator []=(int index, int value) {
    _view[index] = value;
  }

  /// A view into the memory.
  Uint8List get view => _view;

  /// Grow the memory by [deltaPages] and invalidates any existing views into
  /// the memory.
  void grow(int deltaPages) {
    runtime.growMemory(_mem, deltaPages);
    _view = runtime.memoryView(_mem);
  }
}

/// A callable function from a [WasmInstance].
///
/// Access by calling [WasmInstance.lookupFunction].
class WasmFunction {
  final String _name;
  final Pointer<WasmerFunc> _func;
  final List<int> _argTypes;
  final int _returnType;
  final Pointer<WasmerValVec> _args = calloc<WasmerValVec>();
  final Pointer<WasmerValVec> _results = calloc<WasmerValVec>();

  WasmFunction._(this._name, this._func, this._argTypes, this._returnType) {
    _args.ref.length = _argTypes.length;
    _args.ref.data =
        _argTypes.isEmpty ? nullptr : calloc<WasmerVal>(_argTypes.length);
    _results.ref.length = _returnType == wasmerValKindVoid ? 0 : 1;
    _results.ref.data =
        _returnType == wasmerValKindVoid ? nullptr : calloc<WasmerVal>();
    for (var i = 0; i < _argTypes.length; ++i) {
      _args.ref.data[i].kind = _argTypes[i];
    }
  }

  @override
  String toString() => getSignatureString(_name, _argTypes, _returnType);

  dynamic apply(List<dynamic> args) {
    if (args.length != _argTypes.length) {
      throw ArgumentError('Wrong number arguments for WASM function: $this');
    }
    for (var i = 0; i < args.length; ++i) {
      if (!_args.ref.data[i].fill(_argTypes[i], args[i])) {
        throw ArgumentError('Bad argument type for WASM function: $this');
      }
    }
    runtime.call(_func, _args, _results, toString());

    if (_returnType == wasmerValKindVoid) {
      return null;
    }
    final result = _results.ref.data[0];
    assert(_returnType == result.kind);
    return result.toDynamic;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) {
    if (invocation.memberName == #call) {
      return apply(invocation.positionalArguments);
    }
    return super.noSuchMethod(invocation);
  }
}

/// A global variable.
///
/// To access globals exported from an instance, call
/// [WasmInstance.lookupGlobal].
///
/// To import globals during module instantiation, use
/// [WasmInstanceBuilder.addGlobal].
class WasmGlobal {
  final String _name;
  final Pointer<WasmerGlobal> _global;
  final int _type;
  final int _mut;

  WasmGlobal._(this._name, this._global)
      : _type = runtime.getGlobalKind(runtime.getGlobalType(_global)),
        _mut = runtime.getGlobalMut(runtime.getGlobalType(_global));

  @override
  String toString() =>
      '${wasmerMutabilityName(_mut)} ${wasmerValKindName(_type)} $_name';

  dynamic get value => runtime.globalGet(_global, _type);

  set value(dynamic val) {
    if (_mut == wasmerMutabilityConst) {
      throw _WasmModuleErrorImpl("Can't set value of const global: $this");
    }
    runtime.globalSet(_global, _type, val);
  }
}

class _WasmModuleErrorImpl extends Error implements WasmError {
  @override
  final String message;

  _WasmModuleErrorImpl(
    this.message,
  ) : assert(message.trim() == message);

  @override
  String toString() => 'WasmModuleError: $message';
}
