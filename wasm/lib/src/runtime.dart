// Copyright (c) 2020, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
import 'dart:typed_data';

import 'package:ffi/ffi.dart';

import 'wasm_api.dart';
import 'wasmer_api.dart';

part 'runtime.g.dart';

WasmRuntime wasmRuntimeFactory(
  DynamicLibrary lib,
) =>
    WasmRuntime._(lib);

class WasmRuntime with _WasmRuntimeGeneratedMixin {
  @override
  final DynamicLibrary _lib;
  final _traps = <String, _WasmTrapsEntry>{};
  late final WasmFinalizable<WasmerEngine> _engine;
  late final WasmFinalizable<WasmerStore> _store;
  late final NativeFinalizer _engineFinalizer;
  late final NativeFinalizer _storeFinalizer;
  late final NativeFinalizer _moduleFinalizer;
  late final NativeFinalizer _instanceFinalizer;
  late final NativeFinalizer _trapFinalizer;
  late final NativeFinalizer _memorytypeFinalizer;
  late final NativeFinalizer _memoryFinalizer;
  late final NativeFinalizer _funcFinalizer;
  late final NativeFinalizer _globalFinalizer;

  WasmRuntime._(this._lib) {
    initBindings();

    _engineFinalizer = NativeFinalizer(_engine_delete.cast());
    _storeFinalizer = NativeFinalizer(_store_delete.cast());
    _moduleFinalizer = NativeFinalizer(_module_delete.cast());
    _instanceFinalizer = NativeFinalizer(_instance_delete.cast());
    _trapFinalizer = NativeFinalizer(_trap_delete.cast());
    _memorytypeFinalizer = NativeFinalizer(_memorytype_delete.cast());
    _memoryFinalizer = NativeFinalizer(_memory_delete.cast());
    _funcFinalizer = NativeFinalizer(_func_delete.cast());
    _globalFinalizer = NativeFinalizer(_global_delete.cast());

    _engine = WasmFinalizable(_engine_new(), _engineFinalizer);
    _checkNotEqual(_engine.ptr, nullptr, 'Failed to initialize Wasm engine.');

    _store = WasmFinalizable(_store_new(_engine.ptr), _storeFinalizer);
    _checkNotEqual(_store.ptr, nullptr, 'Failed to create Wasm store.');
  }

  WasmFinalizable<WasmerModule> compile(Uint8List data) {
    final dataPtr = calloc<Uint8>(data.length);
    for (var i = 0; i < data.length; ++i) {
      dataPtr[i] = data[i];
    }
    final dataVec = calloc<WasmerByteVec>();
    dataVec.ref.data = dataPtr;
    dataVec.ref.length = data.length;

    final modulePtr =
        WasmFinalizable(_module_new(_store.ptr, dataVec), _moduleFinalizer);

    calloc
      ..free(dataPtr)
      ..free(dataVec);

    _checkNotEqual(modulePtr.ptr, nullptr, 'Wasm module compilation failed.');
    return modulePtr;
  }

  Pointer _externTypeToFuncOrGlobalType(
    int kind,
    Pointer<WasmerExterntype> extern,
  ) {
    if (kind == wasmerExternKindFunction) {
      return _externtype_as_functype(extern);
    } else if (kind == wasmerExternKindGlobal) {
      return _externtype_as_globaltype(extern);
    }
    return nullptr;
  }

  List<WasmExportDescriptor> exportDescriptors(Pointer<WasmerModule> module) {
    var exportsVec = calloc<WasmerExporttypeVec>();
    _module_exports(module, exportsVec);
    var exps = <WasmExportDescriptor>[];
    for (var i = 0; i < exportsVec.ref.length; ++i) {
      final exp = exportsVec.ref.data[i];
      final extern = _exporttype_type(exp);
      final kind = _externtype_kind(extern);
      final name = _exporttype_name(exp).ref.toString();
      final type = _externTypeToFuncOrGlobalType(kind, extern);
      exps.add(
        WasmExportDescriptor._(
          kind,
          name,
          type,
          _getImportExportString(kind, name, type),
        ),
      );
    }
    calloc.free(exportsVec);
    return exps;
  }

  List<WasmImportDescriptor> importDescriptors(Pointer<WasmerModule> module) {
    var importsVec = calloc<WasmerImporttypeVec>();
    _module_imports(module, importsVec);
    var imps = <WasmImportDescriptor>[];
    for (var i = 0; i < importsVec.ref.length; ++i) {
      final imp = importsVec.ref.data[i];
      final extern = _importtype_type(imp);
      final kind = _externtype_kind(extern);
      final moduleName = _importtype_module(imp).ref.toString();
      final name = _importtype_name(imp).ref.toString();
      final type = _externTypeToFuncOrGlobalType(kind, extern);
      imps.add(
        WasmImportDescriptor._(
          kind,
          moduleName,
          name,
          type,
          _getImportExportString(kind, '$moduleName::$name', type),
        ),
      );
    }
    calloc.free(importsVec);
    return imps;
  }

  void maybeThrowTrap(Pointer<WasmerTrap> trap, String source) {
    if (trap != nullptr) {
      // There are 2 kinds of trap, and their memory is managed differently.
      // Traps created in the newTrap method below are stored in the traps map
      // with a corresponding exception, and their memory is managed using a
      // finalizer on the _WasmTrapsEntry. Traps can also be created by WASM
      // code, and in that case we delete them in this function.
      final trapMessage = calloc<WasmerByteVec>();
      _trap_message(trap, trapMessage);
      final message = trapMessage.ref.toString();
      _byte_vec_delete(trapMessage);
      calloc.free(trapMessage);
      final entry = _traps.remove(message);
      if (entry == null) {
        // TODO(#87): Report a full stack trace to the user.
        throw _WasmRuntimeExceptionImpl(message);
      }
      // ignore: only_throw_errors
      throw entry.exception;
    }
  }

  WasmFinalizable<WasmerInstance> instantiate(
    Pointer<WasmerModule> module,
    Pointer<WasmerExternVec> imports,
  ) {
    var trap = calloc<Pointer<WasmerTrap>>()..value = nullptr;
    var inst = WasmFinalizable(
        _instance_new(_store.ptr, module, imports, trap), _instanceFinalizer);
    maybeThrowTrap(trap.value, 'module initialization function');
    calloc.free(trap);
    _checkNotEqual(inst.ptr, nullptr, 'Wasm module instantiation failed.');
    return inst;
  }

  // Clean up the exports after use, with deleteExports.
  Pointer<WasmerExternVec> exports(Pointer<WasmerInstance> instancePtr) {
    var exports = calloc<WasmerExternVec>();
    _instance_exports(instancePtr, exports);
    return exports;
  }

  void deleteExports(Pointer<WasmerExternVec> exports) {
    _extern_vec_delete(exports);
    calloc.free(exports);
  }

  int externKind(Pointer<WasmerExtern> extern) => _extern_kind(extern);

  Pointer<WasmerFunc> externToFunction(Pointer<WasmerExtern> extern) =>
      _extern_as_func(extern);

  Pointer<WasmerExtern> functionToExtern(Pointer<WasmerFunc> func) =>
      _func_as_extern(func);

  List<int> getArgTypes(Pointer<WasmerFunctype> funcType) {
    var types = <int>[];
    var args = _functype_params(funcType);
    for (var i = 0; i < args.ref.length; ++i) {
      types.add(_valtype_kind(args.ref.data[i]));
    }
    return types;
  }

  int getReturnType(Pointer<WasmerFunctype> funcType) {
    var rets = _functype_results(funcType);
    if (rets.ref.length == 0) {
      return wasmerValKindVoid;
    } else if (rets.ref.length > 1) {
      throw _WasmRuntimeErrorImpl('Multiple return values are not supported');
    }
    return _valtype_kind(rets.ref.data[0]);
  }

  void call(
    Pointer<WasmerFunc> func,
    Pointer<WasmerValVec> args,
    Pointer<WasmerValVec> results,
    String source,
  ) {
    maybeThrowTrap(_func_call(func, args, results), source);
  }

  Pointer<WasmerMemory> externToMemory(Pointer<WasmerExtern> extern) =>
      _extern_as_memory(extern);

  Pointer<WasmerExtern> memoryToExtern(Pointer<WasmerMemory> memory) =>
      _memory_as_extern(memory);

  WasmFinalizable<WasmerMemory> newMemory(
    int pages,
    int? maxPages,
  ) {
    var limPtr = calloc<WasmerLimits>();
    limPtr.ref.min = pages;
    limPtr.ref.max = maxPages ?? wasmLimitsMaxDefault;
    var memType = _memorytype_new(limPtr);
    calloc.free(limPtr);
    _checkNotEqual(memType, nullptr, 'Failed to create memory type.');
    // TODO: Finalizable for mem type.
    return WasmFinalizable(
        _checkNotEqual(
          _memory_new(_store.ptr, memType),
          nullptr,
          'Failed to create memory.',
        ),
        _memoryFinalizer);
  }

  void growMemory(Pointer<WasmerMemory> memory, int deltaPages) {
    _checkNotEqual(
      _memory_grow(memory, deltaPages),
      0,
      'Failed to grow memory.',
    );
  }

  int memoryLength(Pointer<WasmerMemory> memory) => _memory_size(memory);

  Uint8List memoryView(Pointer<WasmerMemory> memory) =>
      _memory_data(memory).asTypedList(_memory_data_size(memory));

  WasmFinalizable<WasmerFunc> newFunc(
    Pointer<WasmerFunctype> funcType,
    Pointer func,
    Pointer env,
    Pointer finalizer,
  ) {
    var f = WasmFinalizable(
        _func_new_with_env(
          _store.ptr,
          funcType,
          func.cast(),
          env.cast(),
          finalizer.cast(),
        ),
        _funcFinalizer);
    _checkNotEqual(f.ptr, nullptr, 'Failed to create function.');
    return f;
  }

  Pointer<WasmerVal> newValue(int type, dynamic val) {
    final wasmerVal = calloc<WasmerVal>();
    if (!wasmerVal.ref.fill(type, val)) {
      throw _WasmRuntimeErrorImpl(
        'Bad value for WASM type: ${wasmerValKindName(type)}',
      );
    }
    return wasmerVal;
  }

  WasmFinalizable<WasmerGlobal> newGlobal(
    Pointer<WasmerGlobaltype> globalType,
    dynamic val,
  ) {
    final wasmerVal = newValue(getGlobalKind(globalType), val);
    final global = WasmFinalizable(
        _global_new(_store.ptr, globalType, wasmerVal), _globalFinalizer);
    calloc.free(wasmerVal);
    return global;
  }

  Pointer<WasmerGlobaltype> getGlobalType(Pointer<WasmerGlobal> global) =>
      _global_type(global);

  int getGlobalKind(Pointer<WasmerGlobaltype> globalType) =>
      _valtype_kind(_globaltype_content(globalType));

  int getGlobalMut(Pointer<WasmerGlobaltype> globalType) =>
      _globaltype_mutability(globalType);

  Pointer<WasmerGlobal> externToGlobal(Pointer<WasmerExtern> extern) =>
      _extern_as_global(extern);

  Pointer<WasmerExtern> globalToExtern(Pointer<WasmerGlobal> global) =>
      _global_as_extern(global);

  dynamic globalGet(Pointer<WasmerGlobal> global, int type) {
    final wasmerVal = newValue(type, 0);
    _global_get(global, wasmerVal);
    final result = wasmerVal.ref.toDynamic;
    calloc.free(wasmerVal);
    return result;
  }

  void globalSet(Pointer<WasmerGlobal> global, int type, dynamic val) {
    final wasmerVal = newValue(type, val);
    _global_set(global, wasmerVal);
    calloc.free(wasmerVal);
  }

  Pointer<WasmerByteVec> _allocateString(String str) {
    // Allocates both the WasmerByteVec and its internal byte list using calloc.
    // The caller is responsible for freeing both.
    final strList = utf8.encode(str);
    final bytes = calloc<WasmerByteVec>();
    bytes.ref.data = calloc<Uint8>(strList.length);
    for (var i = 0; i < strList.length; ++i) {
      bytes.ref.data[i] = strList[i];
    }
    bytes.ref.length = strList.length;
    return bytes;
  }

  Pointer<WasmerTrap> newTrap(Object exception) {
    final msg = 'dart:${exception.hashCode.toRadixString(36)}';
    final bytes = _allocateString(msg);
    var trap = WasmFinalizable(_trap_new(_store.ptr, bytes), _trapFinalizer);
    calloc
      ..free(bytes.ref.data)
      ..free(bytes);
    _checkNotEqual(trap.ptr, nullptr, 'Failed to create trap.');
    var entry = _WasmTrapsEntry(exception, trap);
    _traps[msg] = entry;
    return trap.ptr;
  }

  Pointer<WasmerWasiConfig> newWasiConfig() {
    var name = calloc<Uint8>();
    name[0] = 0;
    var config = _wasi_config_new(name);
    calloc.free(name);
    return _checkNotEqual(config, nullptr, 'Failed to create WASI config.');
  }

  void captureWasiStdout(Pointer<WasmerWasiConfig> config) {
    _wasi_config_capture_stdout(config);
  }

  void captureWasiStderr(Pointer<WasmerWasiConfig> config) {
    _wasi_config_capture_stderr(config);
  }

  Pointer<WasmerWasiEnv> newWasiEnv(Pointer<WasmerWasiConfig> config) =>
      _checkNotEqual(
        _wasi_env_new(config),
        nullptr,
        'Failed to create WASI environment.',
      );

  void getWasiImports(
    Pointer<WasmerModule> mod,
    Pointer<WasmerWasiEnv> env,
    Pointer<WasmerExternVec> imports,
  ) {
    _checkNotEqual(
      _wasi_get_imports(_store.ptr, mod, env, imports),
      0,
      'Failed to fill WASI imports.',
    );
  }

  Stream<List<int>> getWasiStdoutStream(Pointer<WasmerWasiEnv> env) =>
      Stream.fromIterable(_WasiStreamIterable(env, _wasi_env_read_stdout));

  Stream<List<int>> getWasiStderrStream(Pointer<WasmerWasiEnv> env) =>
      Stream.fromIterable(_WasiStreamIterable(env, _wasi_env_read_stderr));

  String _getLastError() {
    var length = _wasmer_last_error_length();
    var buf = calloc<Uint8>(length);
    _wasmer_last_error_message(buf, length);
    var message = utf8.decode(buf.asTypedList(length));
    calloc.free(buf);
    return message;
  }

  T _checkNotEqual<T>(T x, T y, String errorMessage) {
    if (x == y) {
      throw _WasmRuntimeErrorImpl('$errorMessage\n${_getLastError()}'.trim());
    }
    return x;
  }

  String _getImportExportString(
    int kind,
    String name,
    Pointer type,
  ) {
    final kindName = wasmerExternKindName(kind);
    if (kind == wasmerExternKindFunction) {
      final funcType = type as Pointer<WasmerFunctype>;
      final sig = getSignatureString(
        name,
        getArgTypes(funcType),
        getReturnType(funcType),
      );
      return '$kindName: $sig';
    } else if (kind == wasmerExternKindGlobal) {
      final globalType = type as Pointer<WasmerGlobaltype>;
      final typeName = wasmerValKindName(getGlobalKind(globalType));
      final mutName = wasmerMutabilityName(getGlobalMut(globalType));
      return '$kindName: $mutName $typeName $name';
    } else {
      return '$kindName: $name';
    }
  }
}

// Owns a pointer. The pointer is destroyed when this object is GC'd.
class WasmFinalizable<T extends NativeType> implements Finalizable {
  final Pointer<T> ptr;

  WasmFinalizable(this.ptr, NativeFinalizer finalizer) {
    if (ptr != nullptr) {
      finalizer.attach(this, ptr.cast(), detach: this);
    }
  }

  // Constructs a WasmFinalizable without taking ownership of the pointer.
  WasmFinalizable.unowned(this.ptr);
}

class WasmImportDescriptor {
  final int kind;
  final String moduleName;
  final String name;
  final Pointer type;
  final String description;

  const WasmImportDescriptor._(
    this.kind,
    this.moduleName,
    this.name,
    this.type,
    this.description,
  );

  @override
  String toString() => description;
}

class WasmExportDescriptor {
  final int kind;
  final String name;
  final Pointer type;
  final String description;

  const WasmExportDescriptor._(
    this.kind,
    this.name,
    this.type,
    this.description,
  );

  @override
  String toString() => description;
}

class _WasmTrapsEntry {
  final Object exception;
  final WasmFinalizable trap;

  _WasmTrapsEntry(this.exception, this.trap);
}

class _WasiStreamIterator implements Iterator<List<int>> {
  static const int _bufferLength = 1024;
  final Pointer<Uint8> _buf = calloc<Uint8>(_bufferLength);
  final Pointer<WasmerWasiEnv> _env;
  final Function _reader;
  int _length = 0;

  _WasiStreamIterator(this._env, this._reader);

  @override
  bool moveNext() {
    _length = _reader(_env, _buf, _bufferLength) as int;
    return _length >= 0;
  }

  @override
  List<int> get current => _buf.asTypedList(_length);
}

class _WasiStreamIterable extends Iterable<List<int>> {
  final Pointer<WasmerWasiEnv> _env;
  final Function _reader;

  _WasiStreamIterable(this._env, this._reader);

  @override
  Iterator<List<int>> get iterator => _WasiStreamIterator(_env, _reader);
}

String getSignatureString(
  String name,
  List<int> argTypes,
  int returnType,
) =>
    '${wasmerValKindName(returnType)} '
    '$name(${argTypes.map(wasmerValKindName).join(', ')})';

class _WasmRuntimeErrorImpl extends Error implements WasmError {
  @override
  final String message;

  _WasmRuntimeErrorImpl(
    this.message,
  ) : assert(message.trim() == message);

  @override
  String toString() => 'WasmRuntimeError: $message';
}

class _WasmRuntimeExceptionImpl implements WasmException {
  @override
  final String message;

  const _WasmRuntimeExceptionImpl(
    this.message,
  );

  @override
  String toString() => 'WasmRuntimeException: $message';
}
