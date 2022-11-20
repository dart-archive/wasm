// Copyright (c) 2020, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:typed_data';

import '../wasm_api.dart';

Future<WasmModule> wasmModuleCompileAsync(
  Uint8List data,
) async {
  throw Exception('The web is not supported yet.');
}

WasmModule wasmModuleCompileSync(
  Uint8List data,
) {
  throw Exception('The web is not supported yet.');
}
