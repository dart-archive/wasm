// Copyright (c) 2020, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:ffi';
import 'dart:typed_data';

import 'package:ffi/ffi.dart';

import 'runtime.dart';
import 'wasm_api.dart';
import 'wasmer_api.dart';
import 'wasmer_locator.dart';

/// Creates a new wasm module asynchronously.
Future<WasmModule> wasmModuleCompileAsync(
  Uint8List data,
) async =>
    wasmModuleCompileSync(data);

/// Creates a new wasm module synchronously.
WasmModule wasmModuleCompileSync(
  Uint8List data,
) =>
    _WasmModule(data, _runtime);

final WasmRuntime _runtime = wasmRuntimeFactory(
  loadWasmerDynamicLibrary(),
);

class _WasmModule implements WasmModule {
  late final Pointer<WasmerModule> _module;
  final WasmRuntime runtime;

  _WasmModule(Uint8List data, this.runtime) {
    _module = runtime.compile(this, data);
  }

  @override
  _WasmInstanceBuilder builder() => _WasmInstanceBuilder._(this);

  @override
  _WasmMemory createMemory(int pages, [int? maxPages]) =>
      _WasmMemory._create(pages, maxPages, runtime);

  @override
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
    return _runtime.newTrap(exception);
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
    final args = <dynamic>[];
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

class _WasmInstanceBuilder implements WasmInstanceBuilder {
  final _importOwner = _WasmImportOwner();
  final _importIndex = <String, int>{};
  final _imports = calloc<WasmerExternVec>();
  final _WasmModule _module;
  late final List<WasmImportDescriptor> _importDescs;
  Pointer<WasmerWasiEnv> _wasiEnv = nullptr;

  _WasmInstanceBuilder._(this._module)
      : _importDescs = _module.runtime.importDescriptors(_module._module) {
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

  @override
  void addMemory(
    String moduleName,
    String name,
    // As long as WasmMemory is sealed, the use of covariant will be safe here.
    covariant _WasmMemory memory,
  ) {
    final index = _getIndex(moduleName, name);
    final imp = _importDescs[index];
    if (imp.kind != wasmerExternKindMemory) {
      throw _WasmModuleErrorImpl('Import is not a memory: $imp');
    }
    _imports.ref.data[index] = _module.runtime.memoryToExtern(memory._mem);
  }

  @override
  void addFunction(String moduleName, String name, Function fn) {
    final index = _getIndex(moduleName, name);
    final imp = _importDescs[index];

    if (imp.kind != wasmerExternKindFunction) {
      throw _WasmModuleErrorImpl('Import is not a function: $imp');
    }

    final funcType = imp.type as Pointer<WasmerFunctype>;
    final returnType = _module.runtime.getReturnType(funcType);
    final wasmFnImport = calloc<_WasmFnImport>();
    wasmFnImport.ref.returnType = returnType;
    _wasmFnImportToFn[wasmFnImport.address] = fn;
    final fnImp = _module.runtime.newFunc(
      _importOwner,
      funcType,
      _wasmFnImportTrampolineNative,
      wasmFnImport,
      nullptr, // TODO(#47): Re-enable _wasmFnImportFinalizerNative.
    );
    _imports.ref.data[index] = _module.runtime.functionToExtern(fnImp);
  }

  @override
  _WasmGlobal addGlobal(String moduleName, String name, dynamic val) {
    final index = _getIndex(moduleName, name);
    final imp = _importDescs[index];

    if (imp.kind != wasmerExternKindGlobal) {
      throw _WasmModuleErrorImpl('Import is not a global: $imp');
    }

    final globalType = imp.type as Pointer<WasmerGlobaltype>;
    final global = _module.runtime.newGlobal(_importOwner, globalType, val);
    _imports.ref.data[index] = _module.runtime.globalToExtern(global);
    return _WasmGlobal._(
      '${imp.moduleName}::${imp.name}',
      global,
      _module.runtime,
    );
  }

  @override
  void enableWasi({
    bool captureStdout = false,
    bool captureStderr = false,
  }) {
    if (_wasiEnv != nullptr) {
      throw _WasmModuleErrorImpl('WASI is already enabled.');
    }
    final config = _module.runtime.newWasiConfig();
    if (captureStdout) _module.runtime.captureWasiStdout(config);
    if (captureStderr) _module.runtime.captureWasiStderr(config);
    _wasiEnv = _module.runtime.newWasiEnv(config);
    _module.runtime.getWasiImports(_module._module, _wasiEnv, _imports);
  }

  @override
  _WasmInstance build() {
    for (var i = 0; i < _importDescs.length; ++i) {
      if (_imports.ref.data[i] == nullptr) {
        throw _WasmModuleErrorImpl('Missing import: ${_importDescs[i]}');
      }
    }
    return _WasmInstance._(_module, _importOwner, _imports, _wasiEnv);
  }

  @override
  Future<_WasmInstance> buildAsync() async => Future<_WasmInstance>(build);
}

// TODO: should not be required once the min supported Dart SDK includes
//  github.com/dart-lang/sdk/commit/8fd81f72281d9d3aa5ef3890c947cc7305c56a50
class _WasmImportOwner {}

class _WasmInstance implements WasmInstance {
  final _WasmImportOwner _importOwner;
  final _functions = <String, _WasmFunction>{};
  final _globals = <String, _WasmGlobal>{};
  final _WasmModule _module;
  final Pointer<WasmerWasiEnv> _wasiEnv;

  late final Pointer<WasmerInstance> _instance;

  Pointer<WasmerMemory>? _exportedMemory;
  Stream<List<int>>? _stdout;
  Stream<List<int>>? _stderr;

  _WasmInstance._(
    this._module,
    this._importOwner,
    Pointer<WasmerExternVec> imports,
    this._wasiEnv,
  ) {
    _instance = _module.runtime.instantiate(
      _importOwner,
      _module._module,
      imports,
    );
    final exports = _module.runtime.exports(_instance);
    final exportDescs = _module.runtime.exportDescriptors(_module._module);
    assert(exports.ref.length == exportDescs.length);
    for (var i = 0; i < exports.ref.length; ++i) {
      final e = exports.ref.data[i];
      final kind = _module.runtime.externKind(exports.ref.data[i]);
      final name = exportDescs[i].name;
      if (kind == wasmerExternKindFunction) {
        final f = _module.runtime.externToFunction(e);
        final ft = exportDescs[i].type as Pointer<WasmerFunctype>;
        _functions[name] = _WasmFunction._(
          name,
          f,
          _module.runtime.getArgTypes(ft),
          _module.runtime.getReturnType(ft),
          _module.runtime,
        );
      } else if (kind == wasmerExternKindMemory) {
        // WASM currently allows only one memory per module.
        final mem = _module.runtime.externToMemory(e);
        _exportedMemory = mem;
      } else if (kind == wasmerExternKindGlobal) {
        _globals[name] = _WasmGlobal._(
          name,
          _module.runtime.externToGlobal(e),
          _module.runtime,
        );
      }
    }
  }

  @override
  dynamic lookupFunction(String name) => _functions[name];

  @override
  _WasmGlobal? lookupGlobal(String name) => _globals[name];

  @override
  _WasmMemory get memory {
    if (_exportedMemory == null) {
      throw _WasmModuleErrorImpl('Wasm module did not export its memory.');
    }
    return _WasmMemory._fromExport(
      _exportedMemory as Pointer<WasmerMemory>,
      _module.runtime,
    );
  }

  @override
  Stream<List<int>> get stdout {
    if (_wasiEnv == nullptr) {
      throw _WasmModuleErrorImpl("Can't capture stdout without WASI enabled.");
    }
    return _stdout ??= _module.runtime.getWasiStdoutStream(_wasiEnv);
  }

  @override
  Stream<List<int>> get stderr {
    if (_wasiEnv == nullptr) {
      throw _WasmModuleErrorImpl("Can't capture stderr without WASI enabled.");
    }
    return _stderr ??= _module.runtime.getWasiStderrStream(_wasiEnv);
  }
}

class _WasmMemory implements WasmMemory {
  late final Pointer<WasmerMemory> _mem;
  late Uint8List _view;
  final WasmRuntime runtime;

  _WasmMemory._fromExport(this._mem, this.runtime) {
    _view = runtime.memoryView(_mem);
  }

  _WasmMemory._create(int pages, int? maxPages, this.runtime) {
    _mem = runtime.newMemory(this, pages, maxPages);
    _view = runtime.memoryView(_mem);
  }

  @override
  int get lengthInPages => runtime.memoryLength(_mem);

  @override
  int get lengthInBytes => _view.lengthInBytes;

  @override
  int operator [](int index) => _view[index];

  @override
  void operator []=(int index, int value) {
    _view[index] = value;
  }

  @override
  Uint8List get view => _view;

  @override
  void grow(int deltaPages) {
    runtime.growMemory(_mem, deltaPages);
    _view = runtime.memoryView(_mem);
  }
}

class _WasmFunction implements WasmFunction {
  final String _name;
  final Pointer<WasmerFunc> _func;
  final List<int> _argTypes;
  final int _returnType;
  final Pointer<WasmerValVec> _args = calloc<WasmerValVec>();
  final Pointer<WasmerValVec> _results = calloc<WasmerValVec>();
  final WasmRuntime runtime;

  _WasmFunction._(
    this._name,
    this._func,
    this._argTypes,
    this._returnType,
    this.runtime,
  ) {
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

  @override
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

class _WasmGlobal implements WasmGlobal {
  final String _name;
  final Pointer<WasmerGlobal> _global;
  final int _type;
  final int _mut;
  final WasmRuntime runtime;

  _WasmGlobal._(this._name, this._global, this.runtime)
      : _type = runtime.getGlobalKind(runtime.getGlobalType(_global)),
        _mut = runtime.getGlobalMut(runtime.getGlobalType(_global));

  @override
  String toString() =>
      '${wasmerMutabilityName(_mut)} ${wasmerValKindName(_type)} $_name';

  @override
  dynamic get value => runtime.globalGet(_global, _type);

  @override
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
