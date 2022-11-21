// Copyright (c) 2020, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// This file has been automatically generated. Please do not edit it manually.
// To regenerate the file, use the following command
// "generate_ffi_boilerplate.py".

// ignore_for_file: non_constant_identifier_names
// ignore_for_file: unused_field
// ignore_for_file: require_trailing_commas

part of 'runtime.dart';

mixin _WasmRuntimeGeneratedMixin {
  late final WasmerDartInitializeApiDLFn _Dart_InitializeApiDL;
  late final WasmerSetFinalizerForEngineFn _set_finalizer_for_engine;
  late final WasmerSetFinalizerForFuncFn _set_finalizer_for_func;
  late final WasmerSetFinalizerForGlobalFn _set_finalizer_for_global;
  late final WasmerSetFinalizerForInstanceFn _set_finalizer_for_instance;
  late final WasmerSetFinalizerForMemoryFn _set_finalizer_for_memory;
  late final WasmerSetFinalizerForMemorytypeFn _set_finalizer_for_memorytype;
  late final WasmerSetFinalizerForModuleFn _set_finalizer_for_module;
  late final WasmerSetFinalizerForStoreFn _set_finalizer_for_store;
  late final WasmerSetFinalizerForTrapFn _set_finalizer_for_trap;
  late final WasmerWasiConfigCaptureStderrFn _wasi_config_capture_stderr;
  late final WasmerWasiConfigCaptureStdoutFn _wasi_config_capture_stdout;
  late final WasmerWasiConfigNewFn _wasi_config_new;
  late final WasmerWasiEnvDeleteFn _wasi_env_delete;
  late final WasmerWasiEnvNewFn _wasi_env_new;
  late final WasmerWasiEnvReadStderrFn _wasi_env_read_stderr;
  late final WasmerWasiEnvReadStdoutFn _wasi_env_read_stdout;
  late final WasmerWasiGetImportsFn _wasi_get_imports;
  late final WasmerByteVecDeleteFn _byte_vec_delete;
  late final WasmerByteVecNewFn _byte_vec_new;
  late final WasmerByteVecNewEmptyFn _byte_vec_new_empty;
  late final WasmerByteVecNewUninitializedFn _byte_vec_new_uninitialized;
  late final WasmerEngineDeleteFn _engine_delete;
  late final WasmerEngineNewFn _engine_new;
  late final WasmerExporttypeNameFn _exporttype_name;
  late final WasmerExporttypeTypeFn _exporttype_type;
  late final WasmerExporttypeVecDeleteFn _exporttype_vec_delete;
  late final WasmerExporttypeVecNewFn _exporttype_vec_new;
  late final WasmerExporttypeVecNewEmptyFn _exporttype_vec_new_empty;
  late final WasmerExporttypeVecNewUninitializedFn
      _exporttype_vec_new_uninitialized;
  late final WasmerExternAsFuncFn _extern_as_func;
  late final WasmerExternAsGlobalFn _extern_as_global;
  late final WasmerExternAsMemoryFn _extern_as_memory;
  late final WasmerExternDeleteFn _extern_delete;
  late final WasmerExternKindFn _extern_kind;
  late final WasmerExternVecDeleteFn _extern_vec_delete;
  late final WasmerExternVecNewFn _extern_vec_new;
  late final WasmerExternVecNewEmptyFn _extern_vec_new_empty;
  late final WasmerExternVecNewUninitializedFn _extern_vec_new_uninitialized;
  late final WasmerExterntypeAsFunctypeFn _externtype_as_functype;
  late final WasmerExterntypeAsGlobaltypeFn _externtype_as_globaltype;
  late final WasmerExterntypeDeleteFn _externtype_delete;
  late final WasmerExterntypeKindFn _externtype_kind;
  late final WasmerFuncAsExternFn _func_as_extern;
  late final WasmerFuncCallFn _func_call;
  late final WasmerFuncDeleteFn _func_delete;
  late final WasmerFuncNewWithEnvFn _func_new_with_env;
  late final WasmerFunctypeDeleteFn _functype_delete;
  late final WasmerFunctypeParamsFn _functype_params;
  late final WasmerFunctypeResultsFn _functype_results;
  late final WasmerGlobalAsExternFn _global_as_extern;
  late final WasmerGlobalDeleteFn _global_delete;
  late final WasmerGlobalGetFn _global_get;
  late final WasmerGlobalNewFn _global_new;
  late final WasmerGlobalSetFn _global_set;
  late final WasmerGlobalTypeFn _global_type;
  late final WasmerGlobaltypeContentFn _globaltype_content;
  late final WasmerGlobaltypeDeleteFn _globaltype_delete;
  late final WasmerGlobaltypeMutabilityFn _globaltype_mutability;
  late final WasmerImporttypeModuleFn _importtype_module;
  late final WasmerImporttypeNameFn _importtype_name;
  late final WasmerImporttypeTypeFn _importtype_type;
  late final WasmerImporttypeVecDeleteFn _importtype_vec_delete;
  late final WasmerImporttypeVecNewFn _importtype_vec_new;
  late final WasmerImporttypeVecNewEmptyFn _importtype_vec_new_empty;
  late final WasmerImporttypeVecNewUninitializedFn
      _importtype_vec_new_uninitialized;
  late final WasmerInstanceDeleteFn _instance_delete;
  late final WasmerInstanceExportsFn _instance_exports;
  late final WasmerInstanceNewFn _instance_new;
  late final WasmerMemoryAsExternFn _memory_as_extern;
  late final WasmerMemoryDataFn _memory_data;
  late final WasmerMemoryDataSizeFn _memory_data_size;
  late final WasmerMemoryDeleteFn _memory_delete;
  late final WasmerMemoryGrowFn _memory_grow;
  late final WasmerMemoryNewFn _memory_new;
  late final WasmerMemorySizeFn _memory_size;
  late final WasmerMemorytypeDeleteFn _memorytype_delete;
  late final WasmerMemorytypeNewFn _memorytype_new;
  late final WasmerModuleDeleteFn _module_delete;
  late final WasmerModuleExportsFn _module_exports;
  late final WasmerModuleImportsFn _module_imports;
  late final WasmerModuleNewFn _module_new;
  late final WasmerStoreDeleteFn _store_delete;
  late final WasmerStoreNewFn _store_new;
  late final WasmerTrapDeleteFn _trap_delete;
  late final WasmerTrapMessageFn _trap_message;
  late final WasmerTrapNewFn _trap_new;
  late final WasmerValtypeDeleteFn _valtype_delete;
  late final WasmerValtypeKindFn _valtype_kind;
  late final WasmerValtypeVecDeleteFn _valtype_vec_delete;
  late final WasmerValtypeVecNewFn _valtype_vec_new;
  late final WasmerValtypeVecNewEmptyFn _valtype_vec_new_empty;
  late final WasmerValtypeVecNewUninitializedFn _valtype_vec_new_uninitialized;
  late final WasmerWasmerLastErrorLengthFn _wasmer_last_error_length;
  late final WasmerWasmerLastErrorMessageFn _wasmer_last_error_message;

  void initBindings(DynamicLibrary _lib) {
    _Dart_InitializeApiDL = _lib.lookupFunction<
        NativeWasmerDartInitializeApiDLFn, WasmerDartInitializeApiDLFn>(
      'Dart_InitializeApiDL',
    );
    _set_finalizer_for_engine = _lib.lookupFunction<
        NativeWasmerSetFinalizerForEngineFn, WasmerSetFinalizerForEngineFn>(
      'set_finalizer_for_engine',
    );
    _set_finalizer_for_func = _lib.lookupFunction<
        NativeWasmerSetFinalizerForFuncFn, WasmerSetFinalizerForFuncFn>(
      'set_finalizer_for_func',
    );
    _set_finalizer_for_global = _lib.lookupFunction<
        NativeWasmerSetFinalizerForGlobalFn, WasmerSetFinalizerForGlobalFn>(
      'set_finalizer_for_global',
    );
    _set_finalizer_for_instance = _lib.lookupFunction<
        NativeWasmerSetFinalizerForInstanceFn, WasmerSetFinalizerForInstanceFn>(
      'set_finalizer_for_instance',
    );
    _set_finalizer_for_memory = _lib.lookupFunction<
        NativeWasmerSetFinalizerForMemoryFn, WasmerSetFinalizerForMemoryFn>(
      'set_finalizer_for_memory',
    );
    _set_finalizer_for_memorytype = _lib.lookupFunction<
        NativeWasmerSetFinalizerForMemorytypeFn,
        WasmerSetFinalizerForMemorytypeFn>(
      'set_finalizer_for_memorytype',
    );
    _set_finalizer_for_module = _lib.lookupFunction<
        NativeWasmerSetFinalizerForModuleFn, WasmerSetFinalizerForModuleFn>(
      'set_finalizer_for_module',
    );
    _set_finalizer_for_store = _lib.lookupFunction<
        NativeWasmerSetFinalizerForStoreFn, WasmerSetFinalizerForStoreFn>(
      'set_finalizer_for_store',
    );
    _set_finalizer_for_trap = _lib.lookupFunction<
        NativeWasmerSetFinalizerForTrapFn, WasmerSetFinalizerForTrapFn>(
      'set_finalizer_for_trap',
    );
    _wasi_config_capture_stderr = _lib.lookupFunction<
        NativeWasmerWasiConfigCaptureStderrFn, WasmerWasiConfigCaptureStderrFn>(
      'wasi_config_capture_stderr',
    );
    _wasi_config_capture_stdout = _lib.lookupFunction<
        NativeWasmerWasiConfigCaptureStdoutFn, WasmerWasiConfigCaptureStdoutFn>(
      'wasi_config_capture_stdout',
    );
    _wasi_config_new =
        _lib.lookupFunction<NativeWasmerWasiConfigNewFn, WasmerWasiConfigNewFn>(
      'wasi_config_new',
    );
    _wasi_env_delete =
        _lib.lookupFunction<NativeWasmerWasiEnvDeleteFn, WasmerWasiEnvDeleteFn>(
      'wasi_env_delete',
    );
    _wasi_env_new =
        _lib.lookupFunction<NativeWasmerWasiEnvNewFn, WasmerWasiEnvNewFn>(
      'wasi_env_new',
    );
    _wasi_env_read_stderr = _lib.lookupFunction<NativeWasmerWasiEnvReadStderrFn,
        WasmerWasiEnvReadStderrFn>(
      'wasi_env_read_stderr',
    );
    _wasi_env_read_stdout = _lib.lookupFunction<NativeWasmerWasiEnvReadStdoutFn,
        WasmerWasiEnvReadStdoutFn>(
      'wasi_env_read_stdout',
    );
    _wasi_get_imports = _lib
        .lookupFunction<NativeWasmerWasiGetImportsFn, WasmerWasiGetImportsFn>(
      'wasi_get_imports',
    );
    _byte_vec_delete =
        _lib.lookupFunction<NativeWasmerByteVecDeleteFn, WasmerByteVecDeleteFn>(
      'wasm_byte_vec_delete',
    );
    _byte_vec_new =
        _lib.lookupFunction<NativeWasmerByteVecNewFn, WasmerByteVecNewFn>(
      'wasm_byte_vec_new',
    );
    _byte_vec_new_empty = _lib
        .lookupFunction<NativeWasmerByteVecNewEmptyFn, WasmerByteVecNewEmptyFn>(
      'wasm_byte_vec_new_empty',
    );
    _byte_vec_new_uninitialized = _lib.lookupFunction<
        NativeWasmerByteVecNewUninitializedFn, WasmerByteVecNewUninitializedFn>(
      'wasm_byte_vec_new_uninitialized',
    );
    _engine_delete =
        _lib.lookupFunction<NativeWasmerEngineDeleteFn, WasmerEngineDeleteFn>(
      'wasm_engine_delete',
    );
    _engine_new =
        _lib.lookupFunction<NativeWasmerEngineNewFn, WasmerEngineNewFn>(
      'wasm_engine_new',
    );
    _exporttype_name = _lib
        .lookupFunction<NativeWasmerExporttypeNameFn, WasmerExporttypeNameFn>(
      'wasm_exporttype_name',
    );
    _exporttype_type = _lib
        .lookupFunction<NativeWasmerExporttypeTypeFn, WasmerExporttypeTypeFn>(
      'wasm_exporttype_type',
    );
    _exporttype_vec_delete = _lib.lookupFunction<
        NativeWasmerExporttypeVecDeleteFn, WasmerExporttypeVecDeleteFn>(
      'wasm_exporttype_vec_delete',
    );
    _exporttype_vec_new = _lib.lookupFunction<NativeWasmerExporttypeVecNewFn,
        WasmerExporttypeVecNewFn>(
      'wasm_exporttype_vec_new',
    );
    _exporttype_vec_new_empty = _lib.lookupFunction<
        NativeWasmerExporttypeVecNewEmptyFn, WasmerExporttypeVecNewEmptyFn>(
      'wasm_exporttype_vec_new_empty',
    );
    _exporttype_vec_new_uninitialized = _lib.lookupFunction<
        NativeWasmerExporttypeVecNewUninitializedFn,
        WasmerExporttypeVecNewUninitializedFn>(
      'wasm_exporttype_vec_new_uninitialized',
    );
    _extern_as_func =
        _lib.lookupFunction<NativeWasmerExternAsFuncFn, WasmerExternAsFuncFn>(
      'wasm_extern_as_func',
    );
    _extern_as_global = _lib
        .lookupFunction<NativeWasmerExternAsGlobalFn, WasmerExternAsGlobalFn>(
      'wasm_extern_as_global',
    );
    _extern_as_memory = _lib
        .lookupFunction<NativeWasmerExternAsMemoryFn, WasmerExternAsMemoryFn>(
      'wasm_extern_as_memory',
    );
    _extern_delete =
        _lib.lookupFunction<NativeWasmerExternDeleteFn, WasmerExternDeleteFn>(
      'wasm_extern_delete',
    );
    _extern_kind =
        _lib.lookupFunction<NativeWasmerExternKindFn, WasmerExternKindFn>(
      'wasm_extern_kind',
    );
    _extern_vec_delete = _lib
        .lookupFunction<NativeWasmerExternVecDeleteFn, WasmerExternVecDeleteFn>(
      'wasm_extern_vec_delete',
    );
    _extern_vec_new =
        _lib.lookupFunction<NativeWasmerExternVecNewFn, WasmerExternVecNewFn>(
      'wasm_extern_vec_new',
    );
    _extern_vec_new_empty = _lib.lookupFunction<NativeWasmerExternVecNewEmptyFn,
        WasmerExternVecNewEmptyFn>(
      'wasm_extern_vec_new_empty',
    );
    _extern_vec_new_uninitialized = _lib.lookupFunction<
        NativeWasmerExternVecNewUninitializedFn,
        WasmerExternVecNewUninitializedFn>(
      'wasm_extern_vec_new_uninitialized',
    );
    _externtype_as_functype = _lib.lookupFunction<
        NativeWasmerExterntypeAsFunctypeFn, WasmerExterntypeAsFunctypeFn>(
      'wasm_externtype_as_functype',
    );
    _externtype_as_globaltype = _lib.lookupFunction<
        NativeWasmerExterntypeAsGlobaltypeFn, WasmerExterntypeAsGlobaltypeFn>(
      'wasm_externtype_as_globaltype',
    );
    _externtype_delete = _lib.lookupFunction<NativeWasmerExterntypeDeleteFn,
        WasmerExterntypeDeleteFn>(
      'wasm_externtype_delete',
    );
    _externtype_kind = _lib
        .lookupFunction<NativeWasmerExterntypeKindFn, WasmerExterntypeKindFn>(
      'wasm_externtype_kind',
    );
    _func_as_extern =
        _lib.lookupFunction<NativeWasmerFuncAsExternFn, WasmerFuncAsExternFn>(
      'wasm_func_as_extern',
    );
    _func_call = _lib.lookupFunction<NativeWasmerFuncCallFn, WasmerFuncCallFn>(
      'wasm_func_call',
    );
    _func_delete =
        _lib.lookupFunction<NativeWasmerFuncDeleteFn, WasmerFuncDeleteFn>(
      'wasm_func_delete',
    );
    _func_new_with_env = _lib
        .lookupFunction<NativeWasmerFuncNewWithEnvFn, WasmerFuncNewWithEnvFn>(
      'wasm_func_new_with_env',
    );
    _functype_delete = _lib
        .lookupFunction<NativeWasmerFunctypeDeleteFn, WasmerFunctypeDeleteFn>(
      'wasm_functype_delete',
    );
    _functype_params = _lib
        .lookupFunction<NativeWasmerFunctypeParamsFn, WasmerFunctypeParamsFn>(
      'wasm_functype_params',
    );
    _functype_results = _lib
        .lookupFunction<NativeWasmerFunctypeResultsFn, WasmerFunctypeResultsFn>(
      'wasm_functype_results',
    );
    _global_as_extern = _lib
        .lookupFunction<NativeWasmerGlobalAsExternFn, WasmerGlobalAsExternFn>(
      'wasm_global_as_extern',
    );
    _global_delete =
        _lib.lookupFunction<NativeWasmerGlobalDeleteFn, WasmerGlobalDeleteFn>(
      'wasm_global_delete',
    );
    _global_get =
        _lib.lookupFunction<NativeWasmerGlobalGetFn, WasmerGlobalGetFn>(
      'wasm_global_get',
    );
    _global_new =
        _lib.lookupFunction<NativeWasmerGlobalNewFn, WasmerGlobalNewFn>(
      'wasm_global_new',
    );
    _global_set =
        _lib.lookupFunction<NativeWasmerGlobalSetFn, WasmerGlobalSetFn>(
      'wasm_global_set',
    );
    _global_type =
        _lib.lookupFunction<NativeWasmerGlobalTypeFn, WasmerGlobalTypeFn>(
      'wasm_global_type',
    );
    _globaltype_content = _lib.lookupFunction<NativeWasmerGlobaltypeContentFn,
        WasmerGlobaltypeContentFn>(
      'wasm_globaltype_content',
    );
    _globaltype_delete = _lib.lookupFunction<NativeWasmerGlobaltypeDeleteFn,
        WasmerGlobaltypeDeleteFn>(
      'wasm_globaltype_delete',
    );
    _globaltype_mutability = _lib.lookupFunction<
        NativeWasmerGlobaltypeMutabilityFn, WasmerGlobaltypeMutabilityFn>(
      'wasm_globaltype_mutability',
    );
    _importtype_module = _lib.lookupFunction<NativeWasmerImporttypeModuleFn,
        WasmerImporttypeModuleFn>(
      'wasm_importtype_module',
    );
    _importtype_name = _lib
        .lookupFunction<NativeWasmerImporttypeNameFn, WasmerImporttypeNameFn>(
      'wasm_importtype_name',
    );
    _importtype_type = _lib
        .lookupFunction<NativeWasmerImporttypeTypeFn, WasmerImporttypeTypeFn>(
      'wasm_importtype_type',
    );
    _importtype_vec_delete = _lib.lookupFunction<
        NativeWasmerImporttypeVecDeleteFn, WasmerImporttypeVecDeleteFn>(
      'wasm_importtype_vec_delete',
    );
    _importtype_vec_new = _lib.lookupFunction<NativeWasmerImporttypeVecNewFn,
        WasmerImporttypeVecNewFn>(
      'wasm_importtype_vec_new',
    );
    _importtype_vec_new_empty = _lib.lookupFunction<
        NativeWasmerImporttypeVecNewEmptyFn, WasmerImporttypeVecNewEmptyFn>(
      'wasm_importtype_vec_new_empty',
    );
    _importtype_vec_new_uninitialized = _lib.lookupFunction<
        NativeWasmerImporttypeVecNewUninitializedFn,
        WasmerImporttypeVecNewUninitializedFn>(
      'wasm_importtype_vec_new_uninitialized',
    );
    _instance_delete = _lib
        .lookupFunction<NativeWasmerInstanceDeleteFn, WasmerInstanceDeleteFn>(
      'wasm_instance_delete',
    );
    _instance_exports = _lib
        .lookupFunction<NativeWasmerInstanceExportsFn, WasmerInstanceExportsFn>(
      'wasm_instance_exports',
    );
    _instance_new =
        _lib.lookupFunction<NativeWasmerInstanceNewFn, WasmerInstanceNewFn>(
      'wasm_instance_new',
    );
    _memory_as_extern = _lib
        .lookupFunction<NativeWasmerMemoryAsExternFn, WasmerMemoryAsExternFn>(
      'wasm_memory_as_extern',
    );
    _memory_data =
        _lib.lookupFunction<NativeWasmerMemoryDataFn, WasmerMemoryDataFn>(
      'wasm_memory_data',
    );
    _memory_data_size = _lib
        .lookupFunction<NativeWasmerMemoryDataSizeFn, WasmerMemoryDataSizeFn>(
      'wasm_memory_data_size',
    );
    _memory_delete =
        _lib.lookupFunction<NativeWasmerMemoryDeleteFn, WasmerMemoryDeleteFn>(
      'wasm_memory_delete',
    );
    _memory_grow =
        _lib.lookupFunction<NativeWasmerMemoryGrowFn, WasmerMemoryGrowFn>(
      'wasm_memory_grow',
    );
    _memory_new =
        _lib.lookupFunction<NativeWasmerMemoryNewFn, WasmerMemoryNewFn>(
      'wasm_memory_new',
    );
    _memory_size =
        _lib.lookupFunction<NativeWasmerMemorySizeFn, WasmerMemorySizeFn>(
      'wasm_memory_size',
    );
    _memorytype_delete = _lib.lookupFunction<NativeWasmerMemorytypeDeleteFn,
        WasmerMemorytypeDeleteFn>(
      'wasm_memorytype_delete',
    );
    _memorytype_new =
        _lib.lookupFunction<NativeWasmerMemorytypeNewFn, WasmerMemorytypeNewFn>(
      'wasm_memorytype_new',
    );
    _module_delete =
        _lib.lookupFunction<NativeWasmerModuleDeleteFn, WasmerModuleDeleteFn>(
      'wasm_module_delete',
    );
    _module_exports =
        _lib.lookupFunction<NativeWasmerModuleExportsFn, WasmerModuleExportsFn>(
      'wasm_module_exports',
    );
    _module_imports =
        _lib.lookupFunction<NativeWasmerModuleImportsFn, WasmerModuleImportsFn>(
      'wasm_module_imports',
    );
    _module_new =
        _lib.lookupFunction<NativeWasmerModuleNewFn, WasmerModuleNewFn>(
      'wasm_module_new',
    );
    _store_delete =
        _lib.lookupFunction<NativeWasmerStoreDeleteFn, WasmerStoreDeleteFn>(
      'wasm_store_delete',
    );
    _store_new = _lib.lookupFunction<NativeWasmerStoreNewFn, WasmerStoreNewFn>(
      'wasm_store_new',
    );
    _trap_delete =
        _lib.lookupFunction<NativeWasmerTrapDeleteFn, WasmerTrapDeleteFn>(
      'wasm_trap_delete',
    );
    _trap_message =
        _lib.lookupFunction<NativeWasmerTrapMessageFn, WasmerTrapMessageFn>(
      'wasm_trap_message',
    );
    _trap_new = _lib.lookupFunction<NativeWasmerTrapNewFn, WasmerTrapNewFn>(
      'wasm_trap_new',
    );
    _valtype_delete =
        _lib.lookupFunction<NativeWasmerValtypeDeleteFn, WasmerValtypeDeleteFn>(
      'wasm_valtype_delete',
    );
    _valtype_kind =
        _lib.lookupFunction<NativeWasmerValtypeKindFn, WasmerValtypeKindFn>(
      'wasm_valtype_kind',
    );
    _valtype_vec_delete = _lib.lookupFunction<NativeWasmerValtypeVecDeleteFn,
        WasmerValtypeVecDeleteFn>(
      'wasm_valtype_vec_delete',
    );
    _valtype_vec_new =
        _lib.lookupFunction<NativeWasmerValtypeVecNewFn, WasmerValtypeVecNewFn>(
      'wasm_valtype_vec_new',
    );
    _valtype_vec_new_empty = _lib.lookupFunction<
        NativeWasmerValtypeVecNewEmptyFn, WasmerValtypeVecNewEmptyFn>(
      'wasm_valtype_vec_new_empty',
    );
    _valtype_vec_new_uninitialized = _lib.lookupFunction<
        NativeWasmerValtypeVecNewUninitializedFn,
        WasmerValtypeVecNewUninitializedFn>(
      'wasm_valtype_vec_new_uninitialized',
    );
    _wasmer_last_error_length = _lib.lookupFunction<
        NativeWasmerWasmerLastErrorLengthFn, WasmerWasmerLastErrorLengthFn>(
      'wasmer_last_error_length',
    );
    _wasmer_last_error_message = _lib.lookupFunction<
        NativeWasmerWasmerLastErrorMessageFn, WasmerWasmerLastErrorMessageFn>(
      'wasmer_last_error_message',
    );
  }
}

// wasm_engine_t
class WasmerEngine extends Opaque {}

// wasm_exporttype_t
class WasmerExporttype extends Opaque {}

// wasm_extern_t
class WasmerExtern extends Opaque {}

// wasm_externtype_t
class WasmerExterntype extends Opaque {}

// wasm_func_t
class WasmerFunc extends Opaque {}

// wasm_functype_t
class WasmerFunctype extends Opaque {}

// wasm_global_t
class WasmerGlobal extends Opaque {}

// wasm_globaltype_t
class WasmerGlobaltype extends Opaque {}

// wasm_importtype_t
class WasmerImporttype extends Opaque {}

// wasm_instance_t
class WasmerInstance extends Opaque {}

// wasm_memory_t
class WasmerMemory extends Opaque {}

// wasm_memorytype_t
class WasmerMemorytype extends Opaque {}

// wasm_module_t
class WasmerModule extends Opaque {}

// wasm_store_t
class WasmerStore extends Opaque {}

// wasm_trap_t
class WasmerTrap extends Opaque {}

// wasm_valtype_t
class WasmerValtype extends Opaque {}

// wasi_config_t
class WasmerWasiConfig extends Opaque {}

// wasi_env_t
class WasmerWasiEnv extends Opaque {}

// wasm_byte_vec_t
class WasmerByteVec extends Struct {
  @Uint64()
  external int length;

  external Pointer<Uint8> data;

  Uint8List get list {
    final l = data.asTypedList(length);
    if (l.last == 0) {
      // Work around https://github.com/wasmerio/wasmer/issues/2439 by dropping
      // extraneous null-terminators.
      return l.sublist(0, l.length - 1);
    }
    return l;
  }

  @override
  String toString() => utf8.decode(list);
}

// wasm_exporttype_vec_t
class WasmerExporttypeVec extends Struct {
  @Uint64()
  external int length;

  external Pointer<Pointer<WasmerExporttype>> data;
}

// wasm_extern_vec_t
class WasmerExternVec extends Struct {
  @Uint64()
  external int length;

  external Pointer<Pointer<WasmerExtern>> data;
}

// wasm_importtype_vec_t
class WasmerImporttypeVec extends Struct {
  @Uint64()
  external int length;

  external Pointer<Pointer<WasmerImporttype>> data;
}

// wasm_val_vec_t
class WasmerValVec extends Struct {
  @Uint64()
  external int length;

  external Pointer<WasmerVal> data;
}

// wasm_valtype_vec_t
class WasmerValtypeVec extends Struct {
  @Uint64()
  external int length;

  external Pointer<Pointer<WasmerValtype>> data;
}

// Dart_InitializeApiDL
typedef NativeWasmerDartInitializeApiDLFn = Int64 Function(Pointer<Void>);
typedef WasmerDartInitializeApiDLFn = int Function(Pointer<Void>);

// set_finalizer_for_engine
typedef NativeWasmerSetFinalizerForEngineFn = Void Function(
    Handle, Pointer<WasmerEngine>);
typedef WasmerSetFinalizerForEngineFn = void Function(
    Object, Pointer<WasmerEngine>);

// set_finalizer_for_func
typedef NativeWasmerSetFinalizerForFuncFn = Void Function(
    Handle, Pointer<WasmerFunc>);
typedef WasmerSetFinalizerForFuncFn = void Function(
    Object, Pointer<WasmerFunc>);

// set_finalizer_for_global
typedef NativeWasmerSetFinalizerForGlobalFn = Void Function(
    Handle, Pointer<WasmerGlobal>);
typedef WasmerSetFinalizerForGlobalFn = void Function(
    Object, Pointer<WasmerGlobal>);

// set_finalizer_for_instance
typedef NativeWasmerSetFinalizerForInstanceFn = Void Function(
    Handle, Pointer<WasmerInstance>);
typedef WasmerSetFinalizerForInstanceFn = void Function(
    Object, Pointer<WasmerInstance>);

// set_finalizer_for_memory
typedef NativeWasmerSetFinalizerForMemoryFn = Void Function(
    Handle, Pointer<WasmerMemory>);
typedef WasmerSetFinalizerForMemoryFn = void Function(
    Object, Pointer<WasmerMemory>);

// set_finalizer_for_memorytype
typedef NativeWasmerSetFinalizerForMemorytypeFn = Void Function(
    Handle, Pointer<WasmerMemorytype>);
typedef WasmerSetFinalizerForMemorytypeFn = void Function(
    Object, Pointer<WasmerMemorytype>);

// set_finalizer_for_module
typedef NativeWasmerSetFinalizerForModuleFn = Void Function(
    Handle, Pointer<WasmerModule>);
typedef WasmerSetFinalizerForModuleFn = void Function(
    Object, Pointer<WasmerModule>);

// set_finalizer_for_store
typedef NativeWasmerSetFinalizerForStoreFn = Void Function(
    Handle, Pointer<WasmerStore>);
typedef WasmerSetFinalizerForStoreFn = void Function(
    Object, Pointer<WasmerStore>);

// set_finalizer_for_trap
typedef NativeWasmerSetFinalizerForTrapFn = Void Function(
    Handle, Pointer<WasmerTrap>);
typedef WasmerSetFinalizerForTrapFn = void Function(
    Object, Pointer<WasmerTrap>);

// wasi_config_capture_stderr
typedef NativeWasmerWasiConfigCaptureStderrFn = Void Function(
    Pointer<WasmerWasiConfig>);
typedef WasmerWasiConfigCaptureStderrFn = void Function(
    Pointer<WasmerWasiConfig>);

// wasi_config_capture_stdout
typedef NativeWasmerWasiConfigCaptureStdoutFn = Void Function(
    Pointer<WasmerWasiConfig>);
typedef WasmerWasiConfigCaptureStdoutFn = void Function(
    Pointer<WasmerWasiConfig>);

// wasi_config_new
typedef NativeWasmerWasiConfigNewFn = Pointer<WasmerWasiConfig> Function(
    Pointer<Uint8>);
typedef WasmerWasiConfigNewFn = Pointer<WasmerWasiConfig> Function(
    Pointer<Uint8>);

// wasi_env_delete
typedef NativeWasmerWasiEnvDeleteFn = Void Function(Pointer<WasmerWasiEnv>);
typedef WasmerWasiEnvDeleteFn = void Function(Pointer<WasmerWasiEnv>);

// wasi_env_new
typedef NativeWasmerWasiEnvNewFn = Pointer<WasmerWasiEnv> Function(
    Pointer<WasmerWasiConfig>);
typedef WasmerWasiEnvNewFn = Pointer<WasmerWasiEnv> Function(
    Pointer<WasmerWasiConfig>);

// wasi_env_read_stderr
typedef NativeWasmerWasiEnvReadStderrFn = Int64 Function(
    Pointer<WasmerWasiEnv>, Pointer<Uint8>, Uint64);
typedef WasmerWasiEnvReadStderrFn = int Function(
    Pointer<WasmerWasiEnv>, Pointer<Uint8>, int);

// wasi_env_read_stdout
typedef NativeWasmerWasiEnvReadStdoutFn = Int64 Function(
    Pointer<WasmerWasiEnv>, Pointer<Uint8>, Uint64);
typedef WasmerWasiEnvReadStdoutFn = int Function(
    Pointer<WasmerWasiEnv>, Pointer<Uint8>, int);

// wasi_get_imports
typedef NativeWasmerWasiGetImportsFn = Uint8 Function(Pointer<WasmerStore>,
    Pointer<WasmerModule>, Pointer<WasmerWasiEnv>, Pointer<WasmerExternVec>);
typedef WasmerWasiGetImportsFn = int Function(Pointer<WasmerStore>,
    Pointer<WasmerModule>, Pointer<WasmerWasiEnv>, Pointer<WasmerExternVec>);

// wasm_byte_vec_delete
typedef NativeWasmerByteVecDeleteFn = Void Function(Pointer<WasmerByteVec>);
typedef WasmerByteVecDeleteFn = void Function(Pointer<WasmerByteVec>);

// wasm_byte_vec_new
typedef NativeWasmerByteVecNewFn = Void Function(
    Pointer<WasmerByteVec>, Uint64, Pointer<Uint8>);
typedef WasmerByteVecNewFn = void Function(
    Pointer<WasmerByteVec>, int, Pointer<Uint8>);

// wasm_byte_vec_new_empty
typedef NativeWasmerByteVecNewEmptyFn = Void Function(Pointer<WasmerByteVec>);
typedef WasmerByteVecNewEmptyFn = void Function(Pointer<WasmerByteVec>);

// wasm_byte_vec_new_uninitialized
typedef NativeWasmerByteVecNewUninitializedFn = Void Function(
    Pointer<WasmerByteVec>, Uint64);
typedef WasmerByteVecNewUninitializedFn = void Function(
    Pointer<WasmerByteVec>, int);

// wasm_engine_delete
typedef NativeWasmerEngineDeleteFn = Void Function(Pointer<WasmerEngine>);
typedef WasmerEngineDeleteFn = void Function(Pointer<WasmerEngine>);

// wasm_engine_new
typedef NativeWasmerEngineNewFn = Pointer<WasmerEngine> Function();
typedef WasmerEngineNewFn = Pointer<WasmerEngine> Function();

// wasm_exporttype_name
typedef NativeWasmerExporttypeNameFn = Pointer<WasmerByteVec> Function(
    Pointer<WasmerExporttype>);
typedef WasmerExporttypeNameFn = Pointer<WasmerByteVec> Function(
    Pointer<WasmerExporttype>);

// wasm_exporttype_type
typedef NativeWasmerExporttypeTypeFn = Pointer<WasmerExterntype> Function(
    Pointer<WasmerExporttype>);
typedef WasmerExporttypeTypeFn = Pointer<WasmerExterntype> Function(
    Pointer<WasmerExporttype>);

// wasm_exporttype_vec_delete
typedef NativeWasmerExporttypeVecDeleteFn = Void Function(
    Pointer<WasmerExporttypeVec>);
typedef WasmerExporttypeVecDeleteFn = void Function(
    Pointer<WasmerExporttypeVec>);

// wasm_exporttype_vec_new
typedef NativeWasmerExporttypeVecNewFn = Void Function(
    Pointer<WasmerExporttypeVec>, Uint64, Pointer<Pointer<WasmerExporttype>>);
typedef WasmerExporttypeVecNewFn = void Function(
    Pointer<WasmerExporttypeVec>, int, Pointer<Pointer<WasmerExporttype>>);

// wasm_exporttype_vec_new_empty
typedef NativeWasmerExporttypeVecNewEmptyFn = Void Function(
    Pointer<WasmerExporttypeVec>);
typedef WasmerExporttypeVecNewEmptyFn = void Function(
    Pointer<WasmerExporttypeVec>);

// wasm_exporttype_vec_new_uninitialized
typedef NativeWasmerExporttypeVecNewUninitializedFn = Void Function(
    Pointer<WasmerExporttypeVec>, Uint64);
typedef WasmerExporttypeVecNewUninitializedFn = void Function(
    Pointer<WasmerExporttypeVec>, int);

// wasm_extern_as_func
typedef NativeWasmerExternAsFuncFn = Pointer<WasmerFunc> Function(
    Pointer<WasmerExtern>);
typedef WasmerExternAsFuncFn = Pointer<WasmerFunc> Function(
    Pointer<WasmerExtern>);

// wasm_extern_as_global
typedef NativeWasmerExternAsGlobalFn = Pointer<WasmerGlobal> Function(
    Pointer<WasmerExtern>);
typedef WasmerExternAsGlobalFn = Pointer<WasmerGlobal> Function(
    Pointer<WasmerExtern>);

// wasm_extern_as_memory
typedef NativeWasmerExternAsMemoryFn = Pointer<WasmerMemory> Function(
    Pointer<WasmerExtern>);
typedef WasmerExternAsMemoryFn = Pointer<WasmerMemory> Function(
    Pointer<WasmerExtern>);

// wasm_extern_delete
typedef NativeWasmerExternDeleteFn = Void Function(Pointer<WasmerExtern>);
typedef WasmerExternDeleteFn = void Function(Pointer<WasmerExtern>);

// wasm_extern_kind
typedef NativeWasmerExternKindFn = Uint8 Function(Pointer<WasmerExtern>);
typedef WasmerExternKindFn = int Function(Pointer<WasmerExtern>);

// wasm_extern_vec_delete
typedef NativeWasmerExternVecDeleteFn = Void Function(Pointer<WasmerExternVec>);
typedef WasmerExternVecDeleteFn = void Function(Pointer<WasmerExternVec>);

// wasm_extern_vec_new
typedef NativeWasmerExternVecNewFn = Void Function(
    Pointer<WasmerExternVec>, Uint64, Pointer<Pointer<WasmerExtern>>);
typedef WasmerExternVecNewFn = void Function(
    Pointer<WasmerExternVec>, int, Pointer<Pointer<WasmerExtern>>);

// wasm_extern_vec_new_empty
typedef NativeWasmerExternVecNewEmptyFn = Void Function(
    Pointer<WasmerExternVec>);
typedef WasmerExternVecNewEmptyFn = void Function(Pointer<WasmerExternVec>);

// wasm_extern_vec_new_uninitialized
typedef NativeWasmerExternVecNewUninitializedFn = Void Function(
    Pointer<WasmerExternVec>, Uint64);
typedef WasmerExternVecNewUninitializedFn = void Function(
    Pointer<WasmerExternVec>, int);

// wasm_externtype_as_functype
typedef NativeWasmerExterntypeAsFunctypeFn = Pointer<WasmerFunctype> Function(
    Pointer<WasmerExterntype>);
typedef WasmerExterntypeAsFunctypeFn = Pointer<WasmerFunctype> Function(
    Pointer<WasmerExterntype>);

// wasm_externtype_as_globaltype
typedef NativeWasmerExterntypeAsGlobaltypeFn = Pointer<WasmerGlobaltype>
    Function(Pointer<WasmerExterntype>);
typedef WasmerExterntypeAsGlobaltypeFn = Pointer<WasmerGlobaltype> Function(
    Pointer<WasmerExterntype>);

// wasm_externtype_delete
typedef NativeWasmerExterntypeDeleteFn = Void Function(
    Pointer<WasmerExterntype>);
typedef WasmerExterntypeDeleteFn = void Function(Pointer<WasmerExterntype>);

// wasm_externtype_kind
typedef NativeWasmerExterntypeKindFn = Uint8 Function(
    Pointer<WasmerExterntype>);
typedef WasmerExterntypeKindFn = int Function(Pointer<WasmerExterntype>);

// wasm_func_as_extern
typedef NativeWasmerFuncAsExternFn = Pointer<WasmerExtern> Function(
    Pointer<WasmerFunc>);
typedef WasmerFuncAsExternFn = Pointer<WasmerExtern> Function(
    Pointer<WasmerFunc>);

// wasm_func_call
typedef NativeWasmerFuncCallFn = Pointer<WasmerTrap> Function(
    Pointer<WasmerFunc>, Pointer<WasmerValVec>, Pointer<WasmerValVec>);
typedef WasmerFuncCallFn = Pointer<WasmerTrap> Function(
    Pointer<WasmerFunc>, Pointer<WasmerValVec>, Pointer<WasmerValVec>);

// wasm_func_delete
typedef NativeWasmerFuncDeleteFn = Void Function(Pointer<WasmerFunc>);
typedef WasmerFuncDeleteFn = void Function(Pointer<WasmerFunc>);

// wasm_func_new_with_env
typedef NativeWasmerFuncNewWithEnvFn = Pointer<WasmerFunc> Function(
    Pointer<WasmerStore>,
    Pointer<WasmerFunctype>,
    Pointer<Void>,
    Pointer<Void>,
    Pointer<Void>);
typedef WasmerFuncNewWithEnvFn = Pointer<WasmerFunc> Function(
    Pointer<WasmerStore>,
    Pointer<WasmerFunctype>,
    Pointer<Void>,
    Pointer<Void>,
    Pointer<Void>);

// wasm_functype_delete
typedef NativeWasmerFunctypeDeleteFn = Void Function(Pointer<WasmerFunctype>);
typedef WasmerFunctypeDeleteFn = void Function(Pointer<WasmerFunctype>);

// wasm_functype_params
typedef NativeWasmerFunctypeParamsFn = Pointer<WasmerValtypeVec> Function(
    Pointer<WasmerFunctype>);
typedef WasmerFunctypeParamsFn = Pointer<WasmerValtypeVec> Function(
    Pointer<WasmerFunctype>);

// wasm_functype_results
typedef NativeWasmerFunctypeResultsFn = Pointer<WasmerValtypeVec> Function(
    Pointer<WasmerFunctype>);
typedef WasmerFunctypeResultsFn = Pointer<WasmerValtypeVec> Function(
    Pointer<WasmerFunctype>);

// wasm_global_as_extern
typedef NativeWasmerGlobalAsExternFn = Pointer<WasmerExtern> Function(
    Pointer<WasmerGlobal>);
typedef WasmerGlobalAsExternFn = Pointer<WasmerExtern> Function(
    Pointer<WasmerGlobal>);

// wasm_global_delete
typedef NativeWasmerGlobalDeleteFn = Void Function(Pointer<WasmerGlobal>);
typedef WasmerGlobalDeleteFn = void Function(Pointer<WasmerGlobal>);

// wasm_global_get
typedef NativeWasmerGlobalGetFn = Void Function(
    Pointer<WasmerGlobal>, Pointer<WasmerVal>);
typedef WasmerGlobalGetFn = void Function(
    Pointer<WasmerGlobal>, Pointer<WasmerVal>);

// wasm_global_new
typedef NativeWasmerGlobalNewFn = Pointer<WasmerGlobal> Function(
    Pointer<WasmerStore>, Pointer<WasmerGlobaltype>, Pointer<WasmerVal>);
typedef WasmerGlobalNewFn = Pointer<WasmerGlobal> Function(
    Pointer<WasmerStore>, Pointer<WasmerGlobaltype>, Pointer<WasmerVal>);

// wasm_global_set
typedef NativeWasmerGlobalSetFn = Void Function(
    Pointer<WasmerGlobal>, Pointer<WasmerVal>);
typedef WasmerGlobalSetFn = void Function(
    Pointer<WasmerGlobal>, Pointer<WasmerVal>);

// wasm_global_type
typedef NativeWasmerGlobalTypeFn = Pointer<WasmerGlobaltype> Function(
    Pointer<WasmerGlobal>);
typedef WasmerGlobalTypeFn = Pointer<WasmerGlobaltype> Function(
    Pointer<WasmerGlobal>);

// wasm_globaltype_content
typedef NativeWasmerGlobaltypeContentFn = Pointer<WasmerValtype> Function(
    Pointer<WasmerGlobaltype>);
typedef WasmerGlobaltypeContentFn = Pointer<WasmerValtype> Function(
    Pointer<WasmerGlobaltype>);

// wasm_globaltype_delete
typedef NativeWasmerGlobaltypeDeleteFn = Void Function(
    Pointer<WasmerGlobaltype>);
typedef WasmerGlobaltypeDeleteFn = void Function(Pointer<WasmerGlobaltype>);

// wasm_globaltype_mutability
typedef NativeWasmerGlobaltypeMutabilityFn = Uint8 Function(
    Pointer<WasmerGlobaltype>);
typedef WasmerGlobaltypeMutabilityFn = int Function(Pointer<WasmerGlobaltype>);

// wasm_importtype_module
typedef NativeWasmerImporttypeModuleFn = Pointer<WasmerByteVec> Function(
    Pointer<WasmerImporttype>);
typedef WasmerImporttypeModuleFn = Pointer<WasmerByteVec> Function(
    Pointer<WasmerImporttype>);

// wasm_importtype_name
typedef NativeWasmerImporttypeNameFn = Pointer<WasmerByteVec> Function(
    Pointer<WasmerImporttype>);
typedef WasmerImporttypeNameFn = Pointer<WasmerByteVec> Function(
    Pointer<WasmerImporttype>);

// wasm_importtype_type
typedef NativeWasmerImporttypeTypeFn = Pointer<WasmerExterntype> Function(
    Pointer<WasmerImporttype>);
typedef WasmerImporttypeTypeFn = Pointer<WasmerExterntype> Function(
    Pointer<WasmerImporttype>);

// wasm_importtype_vec_delete
typedef NativeWasmerImporttypeVecDeleteFn = Void Function(
    Pointer<WasmerImporttypeVec>);
typedef WasmerImporttypeVecDeleteFn = void Function(
    Pointer<WasmerImporttypeVec>);

// wasm_importtype_vec_new
typedef NativeWasmerImporttypeVecNewFn = Void Function(
    Pointer<WasmerImporttypeVec>, Uint64, Pointer<Pointer<WasmerImporttype>>);
typedef WasmerImporttypeVecNewFn = void Function(
    Pointer<WasmerImporttypeVec>, int, Pointer<Pointer<WasmerImporttype>>);

// wasm_importtype_vec_new_empty
typedef NativeWasmerImporttypeVecNewEmptyFn = Void Function(
    Pointer<WasmerImporttypeVec>);
typedef WasmerImporttypeVecNewEmptyFn = void Function(
    Pointer<WasmerImporttypeVec>);

// wasm_importtype_vec_new_uninitialized
typedef NativeWasmerImporttypeVecNewUninitializedFn = Void Function(
    Pointer<WasmerImporttypeVec>, Uint64);
typedef WasmerImporttypeVecNewUninitializedFn = void Function(
    Pointer<WasmerImporttypeVec>, int);

// wasm_instance_delete
typedef NativeWasmerInstanceDeleteFn = Void Function(Pointer<WasmerInstance>);
typedef WasmerInstanceDeleteFn = void Function(Pointer<WasmerInstance>);

// wasm_instance_exports
typedef NativeWasmerInstanceExportsFn = Void Function(
    Pointer<WasmerInstance>, Pointer<WasmerExternVec>);
typedef WasmerInstanceExportsFn = void Function(
    Pointer<WasmerInstance>, Pointer<WasmerExternVec>);

// wasm_instance_new
typedef NativeWasmerInstanceNewFn = Pointer<WasmerInstance> Function(
    Pointer<WasmerStore>,
    Pointer<WasmerModule>,
    Pointer<WasmerExternVec>,
    Pointer<Pointer<WasmerTrap>>);
typedef WasmerInstanceNewFn = Pointer<WasmerInstance> Function(
    Pointer<WasmerStore>,
    Pointer<WasmerModule>,
    Pointer<WasmerExternVec>,
    Pointer<Pointer<WasmerTrap>>);

// wasm_memory_as_extern
typedef NativeWasmerMemoryAsExternFn = Pointer<WasmerExtern> Function(
    Pointer<WasmerMemory>);
typedef WasmerMemoryAsExternFn = Pointer<WasmerExtern> Function(
    Pointer<WasmerMemory>);

// wasm_memory_data
typedef NativeWasmerMemoryDataFn = Pointer<Uint8> Function(
    Pointer<WasmerMemory>);
typedef WasmerMemoryDataFn = Pointer<Uint8> Function(Pointer<WasmerMemory>);

// wasm_memory_data_size
typedef NativeWasmerMemoryDataSizeFn = Uint64 Function(Pointer<WasmerMemory>);
typedef WasmerMemoryDataSizeFn = int Function(Pointer<WasmerMemory>);

// wasm_memory_delete
typedef NativeWasmerMemoryDeleteFn = Void Function(Pointer<WasmerMemory>);
typedef WasmerMemoryDeleteFn = void Function(Pointer<WasmerMemory>);

// wasm_memory_grow
typedef NativeWasmerMemoryGrowFn = Uint8 Function(
    Pointer<WasmerMemory>, Uint32);
typedef WasmerMemoryGrowFn = int Function(Pointer<WasmerMemory>, int);

// wasm_memory_new
typedef NativeWasmerMemoryNewFn = Pointer<WasmerMemory> Function(
    Pointer<WasmerStore>, Pointer<WasmerMemorytype>);
typedef WasmerMemoryNewFn = Pointer<WasmerMemory> Function(
    Pointer<WasmerStore>, Pointer<WasmerMemorytype>);

// wasm_memory_size
typedef NativeWasmerMemorySizeFn = Uint32 Function(Pointer<WasmerMemory>);
typedef WasmerMemorySizeFn = int Function(Pointer<WasmerMemory>);

// wasm_memorytype_delete
typedef NativeWasmerMemorytypeDeleteFn = Void Function(
    Pointer<WasmerMemorytype>);
typedef WasmerMemorytypeDeleteFn = void Function(Pointer<WasmerMemorytype>);

// wasm_memorytype_new
typedef NativeWasmerMemorytypeNewFn = Pointer<WasmerMemorytype> Function(
    Pointer<WasmerLimits>);
typedef WasmerMemorytypeNewFn = Pointer<WasmerMemorytype> Function(
    Pointer<WasmerLimits>);

// wasm_module_delete
typedef NativeWasmerModuleDeleteFn = Void Function(Pointer<WasmerModule>);
typedef WasmerModuleDeleteFn = void Function(Pointer<WasmerModule>);

// wasm_module_exports
typedef NativeWasmerModuleExportsFn = Void Function(
    Pointer<WasmerModule>, Pointer<WasmerExporttypeVec>);
typedef WasmerModuleExportsFn = void Function(
    Pointer<WasmerModule>, Pointer<WasmerExporttypeVec>);

// wasm_module_imports
typedef NativeWasmerModuleImportsFn = Void Function(
    Pointer<WasmerModule>, Pointer<WasmerImporttypeVec>);
typedef WasmerModuleImportsFn = void Function(
    Pointer<WasmerModule>, Pointer<WasmerImporttypeVec>);

// wasm_module_new
typedef NativeWasmerModuleNewFn = Pointer<WasmerModule> Function(
    Pointer<WasmerStore>, Pointer<WasmerByteVec>);
typedef WasmerModuleNewFn = Pointer<WasmerModule> Function(
    Pointer<WasmerStore>, Pointer<WasmerByteVec>);

// wasm_store_delete
typedef NativeWasmerStoreDeleteFn = Void Function(Pointer<WasmerStore>);
typedef WasmerStoreDeleteFn = void Function(Pointer<WasmerStore>);

// wasm_store_new
typedef NativeWasmerStoreNewFn = Pointer<WasmerStore> Function(
    Pointer<WasmerEngine>);
typedef WasmerStoreNewFn = Pointer<WasmerStore> Function(Pointer<WasmerEngine>);

// wasm_trap_delete
typedef NativeWasmerTrapDeleteFn = Void Function(Pointer<WasmerTrap>);
typedef WasmerTrapDeleteFn = void Function(Pointer<WasmerTrap>);

// wasm_trap_message
typedef NativeWasmerTrapMessageFn = Void Function(
    Pointer<WasmerTrap>, Pointer<WasmerByteVec>);
typedef WasmerTrapMessageFn = void Function(
    Pointer<WasmerTrap>, Pointer<WasmerByteVec>);

// wasm_trap_new
typedef NativeWasmerTrapNewFn = Pointer<WasmerTrap> Function(
    Pointer<WasmerStore>, Pointer<WasmerByteVec>);
typedef WasmerTrapNewFn = Pointer<WasmerTrap> Function(
    Pointer<WasmerStore>, Pointer<WasmerByteVec>);

// wasm_valtype_delete
typedef NativeWasmerValtypeDeleteFn = Void Function(Pointer<WasmerValtype>);
typedef WasmerValtypeDeleteFn = void Function(Pointer<WasmerValtype>);

// wasm_valtype_kind
typedef NativeWasmerValtypeKindFn = Uint8 Function(Pointer<WasmerValtype>);
typedef WasmerValtypeKindFn = int Function(Pointer<WasmerValtype>);

// wasm_valtype_vec_delete
typedef NativeWasmerValtypeVecDeleteFn = Void Function(
    Pointer<WasmerValtypeVec>);
typedef WasmerValtypeVecDeleteFn = void Function(Pointer<WasmerValtypeVec>);

// wasm_valtype_vec_new
typedef NativeWasmerValtypeVecNewFn = Void Function(
    Pointer<WasmerValtypeVec>, Uint64, Pointer<Pointer<WasmerValtype>>);
typedef WasmerValtypeVecNewFn = void Function(
    Pointer<WasmerValtypeVec>, int, Pointer<Pointer<WasmerValtype>>);

// wasm_valtype_vec_new_empty
typedef NativeWasmerValtypeVecNewEmptyFn = Void Function(
    Pointer<WasmerValtypeVec>);
typedef WasmerValtypeVecNewEmptyFn = void Function(Pointer<WasmerValtypeVec>);

// wasm_valtype_vec_new_uninitialized
typedef NativeWasmerValtypeVecNewUninitializedFn = Void Function(
    Pointer<WasmerValtypeVec>, Uint64);
typedef WasmerValtypeVecNewUninitializedFn = void Function(
    Pointer<WasmerValtypeVec>, int);

// wasmer_last_error_length
typedef NativeWasmerWasmerLastErrorLengthFn = Int64 Function();
typedef WasmerWasmerLastErrorLengthFn = int Function();

// wasmer_last_error_message
typedef NativeWasmerWasmerLastErrorMessageFn = Int64 Function(
    Pointer<Uint8>, Int64);
typedef WasmerWasmerLastErrorMessageFn = int Function(Pointer<Uint8>, int);
