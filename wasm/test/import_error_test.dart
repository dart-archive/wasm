// Copyright (c) 2021, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// Test errors thrown by imports.
import 'dart:typed_data';

import 'package:test/test.dart';
import 'package:wasm/wasm.dart';

import 'test_shared.dart';

void main() {
  test('bad imports', () {
    // This module expects a function import like:
    // int64_t someFn(int32_t a, int64_t b, float c, double d);
    var data = Uint8List.fromList([
      0x00, 0x61, 0x73, 0x6d, 0x01, 0x00, 0x00, 0x00, 0x01, 0x0c, 0x02, 0x60, //
      0x04, 0x7f, 0x7e, 0x7d, 0x7c, 0x01, 0x7e, 0x60, 0x00, 0x00, 0x02, 0x0e,
      0x01, 0x03, 0x65, 0x6e, 0x76, 0x06, 0x73, 0x6f, 0x6d, 0x65, 0x46, 0x6e,
      0x00, 0x00, 0x03, 0x02, 0x01, 0x01, 0x04, 0x05, 0x01, 0x70, 0x01, 0x01,
      0x01, 0x05, 0x03, 0x01, 0x00, 0x02, 0x06, 0x08, 0x01, 0x7f, 0x01, 0x41,
      0x80, 0x88, 0x04, 0x0b, 0x07, 0x11, 0x02, 0x06, 0x6d, 0x65, 0x6d, 0x6f,
      0x72, 0x79, 0x02, 0x00, 0x04, 0x62, 0x6c, 0x61, 0x68, 0x00, 0x01, 0x0a,
      0x1d, 0x01, 0x1b, 0x00, 0x41, 0x01, 0x42, 0x02, 0x43, 0x00, 0x00, 0x40,
      0x40, 0x44, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x10, 0x40, 0x10, 0x80,
      0x80, 0x80, 0x80, 0x00, 0x1a, 0x0b,
    ]);

    var mod = wasmModuleCompileSync(data);

    // Valid instantiation.
    (mod.builder()
          ..addFunction(
            'env',
            'someFn',
            (int a, int b, num c, double d) => 123,
          ))
        .build();

    // Missing imports.
    expect(
      () => mod.builder().build(),
      throwsWasmError(startsWith('Missing import')),
    );

    // Wrong kind of import.
    expect(
      () => mod.builder().addMemory('env', 'someFn', mod.createMemory(10)),
      throwsWasmError(startsWith('Import is not a memory:')),
    );
    expect(
      () => mod.builder().addGlobal('env', 'someFn', 123),
      throwsWasmError(startsWith('Import is not a global:')),
    );

    // Wrong namespace.
    expect(
      () => (mod.builder()
            ..addFunction(
              'foo',
              'someFn',
              (int a, int b, num c, double d) => 123,
            ))
          .build(),
      throwsWasmError(startsWith('Import not found:')),
    );

    // Wrong name.
    expect(
      () => (mod.builder()
            ..addFunction(
              'env',
              'otherFn',
              (int a, int b, num c, double d) => 123,
            ))
          .build(),
      throwsWasmError(startsWith('Import not found:')),
    );

    // Already filled.
    expect(
      () => (mod.builder()
            ..addFunction(
              'env',
              'someFn',
              (int a, int b, num c, double d) => 123,
            )
            ..addFunction(
              'env',
              'someFn',
              (int a, int b, num c, double d) => 456,
            ))
          .build(),
      throwsWasmError(startsWith('Import already filled: env::someFn')),
    );
  });
}
