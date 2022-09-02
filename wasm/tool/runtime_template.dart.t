// Copyright (c) 2020, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/* <GEN_DOC> */

// ignore_for_file: cascade_invocations
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: unused_field

part of 'runtime.dart';

class WasmRuntime {
  final DynamicLibrary _lib;
  final _traps = <String, _WasmTrapsEntry>{};
  late final Pointer<WasmerEngine> _engine;
  late final Pointer<WasmerStore> _store;

/* <RUNTIME_MEMB> */

  WasmRuntime._init() : _lib = _loadDynamicLib() {
/* <RUNTIME_LOAD> */

    if (_Dart_InitializeApiDL(NativeApi.initializeApiDLData) != 0) {
      throw WasmError('Failed to initialize Dart API');
    }
    _engine = _engine_new();
    _checkNotEqual(_engine, nullptr, 'Failed to initialize Wasm engine.');
    _set_finalizer_for_engine(this, _engine);
    _store = _store_new(_engine);
    _checkNotEqual(_store, nullptr, 'Failed to create Wasm store.');
    _set_finalizer_for_store(this, _store);
  }

  Pointer<WasmerModule> compile(Object owner, Uint8List data) {
    final dataPtr = calloc<Uint8>(data.length);
    for (var i = 0; i < data.length; ++i) {
      dataPtr[i] = data[i];
    }
    final dataVec = calloc<WasmerByteVec>();
    dataVec.ref.data = dataPtr;
    dataVec.ref.length = data.length;

    final modulePtr = _module_new(_store, dataVec);

    calloc.free(dataPtr);
    calloc.free(dataVec);

    _checkNotEqual(modulePtr, nullptr, 'Wasm module compilation failed.');
    _set_finalizer_for_module(owner, modulePtr);
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
      var exp = exportsVec.ref.data[i];
      var extern = _exporttype_type(exp);
      var kind = _externtype_kind(extern);
      exps.add(
        WasmExportDescriptor._(
          kind,
          _exporttype_name(exp).ref.toString(),
          _externTypeToFuncOrGlobalType(kind, extern),
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
      var imp = importsVec.ref.data[i];
      var extern = _importtype_type(imp);
      var kind = _externtype_kind(extern);
      imps.add(
        WasmImportDescriptor._(
          kind,
          _importtype_module(imp).ref.toString(),
          _importtype_name(imp).ref.toString(),
          _externTypeToFuncOrGlobalType(kind, extern),
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
        throw WasmException(message);
      }
      // ignore: only_throw_errors
      throw entry.exception;
    }
  }

  Pointer<WasmerInstance> instantiate(
    Object owner,
    Pointer<WasmerModule> module,
    Pointer<WasmerExternVec> imports,
  ) {
    var trap = calloc<Pointer<WasmerTrap>>();
    trap.value = nullptr;
    var inst = _instance_new(_store, module, imports, trap);
    maybeThrowTrap(trap.value, 'module initialization function');
    calloc.free(trap);
    _checkNotEqual(inst, nullptr, 'Wasm module instantiation failed.');
    _set_finalizer_for_instance(owner, inst);
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
      throw WasmError('Multiple return values are not supported');
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

  Pointer<WasmerMemory> newMemory(
    Object owner,
    int pages,
    int? maxPages,
  ) {
    var limPtr = calloc<WasmerLimits>();
    limPtr.ref.min = pages;
    limPtr.ref.max = maxPages ?? wasmLimitsMaxDefault;
    var memType = _memorytype_new(limPtr);
    calloc.free(limPtr);
    _checkNotEqual(memType, nullptr, 'Failed to create memory type.');
    _set_finalizer_for_memorytype(owner, memType);
    var memory = _checkNotEqual(
      _memory_new(_store, memType),
      nullptr,
      'Failed to create memory.',
    );
    _set_finalizer_for_memory(owner, memory);
    return memory;
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

  Pointer<WasmerFunc> newFunc(
    Object owner,
    Pointer<WasmerFunctype> funcType,
    Pointer func,
    Pointer env,
    Pointer finalizer,
  ) {
    var f = _func_new_with_env(
      _store,
      funcType,
      func.cast(),
      env.cast(),
      finalizer.cast(),
    );
    _checkNotEqual(f, nullptr, 'Failed to create function.');
    _set_finalizer_for_func(owner, f);
    return f;
  }

  Pointer<WasmerVal> newValue(int type, dynamic val) {
    final wasmerVal = calloc<WasmerVal>();
    if (!wasmerVal.ref.fill(type, val)) {
      throw WasmError('Bad value for WASM type: ${wasmerValKindName(type)}');
    }
    return wasmerVal;
  }

  Pointer<WasmerGlobal> newGlobal(
    Object owner,
    Pointer<WasmerGlobaltype> globalType,
    dynamic val,
  ) {
    final wasmerVal = newValue(getGlobalKind(globalType), val);
    final global = _global_new(_store, globalType, wasmerVal);
    _set_finalizer_for_global(owner, global);
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
    var trap = _trap_new(_store, bytes);
    calloc.free(bytes.ref.data);
    calloc.free(bytes);
    _checkNotEqual(trap, nullptr, 'Failed to create trap.');
    var entry = _WasmTrapsEntry(exception);
    _set_finalizer_for_trap(entry, trap);
    _traps[msg] = entry;
    return trap;
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
      _wasi_get_imports(_store, mod, env, imports),
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
      throw WasmError('$errorMessage\n${_getLastError()}'.trim());
    }
    return x;
  }
}
