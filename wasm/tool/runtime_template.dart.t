// Copyright (c) 2020, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/* <GEN_DOC> */

// ignore_for_file: non_constant_identifier_names
// ignore_for_file: unused_field

part of 'runtime.dart';

mixin _WasmRuntimeGeneratedMixin {
  DynamicLibrary get _lib;

/* <RUNTIME_MEMB> */

  void initBindings() {
/* <RUNTIME_LOAD> */

    if (_Dart_InitializeApiDL(NativeApi.initializeApiDLData) != 0) {
      throw _WasmRuntimeErrorImpl('Failed to initialize Dart API');
    }
  }
}
