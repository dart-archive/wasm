// Copyright (c) 2020, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// This file has been automatically generated. Please do not edit it manually.
// To regenerate the file, use the following command
// "generate_ffi_boilerplate.py".

// ignore_for_file: non_constant_identifier_names
// ignore_for_file: unused_field

part of 'runtime.dart';

mixin _WasmRuntimeGeneratedMixin {
  DynamicLibrary get _lib;

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

  void initBindings() {
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

    if (_Dart_InitializeApiDL(NativeApi.initializeApiDLData) != 0) {
      throw _WasmRuntimeErrorImpl('Failed to initialize Dart API');
    }
  }
}
