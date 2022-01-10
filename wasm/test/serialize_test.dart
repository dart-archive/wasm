// Copyright (c) 2021, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// Test that we can serialize and deserialize a wasm module.
import 'dart:typed_data';

import 'package:test/test.dart';
import 'package:wasm/wasm.dart';

void main() {
  test('serializing and deserializing module', () {
    // int64_t square(int64_t n) { return n * n; }
    final data = Uint8List.fromList([
      0x00, 0x61, 0x73, 0x6d, 0x01, 0x00, 0x00, 0x00, 0x01, 0x06, 0x01, 0x60, //
      0x01, 0x7e, 0x01, 0x7e, 0x03, 0x02, 0x01, 0x00, 0x04, 0x05, 0x01, 0x70,
      0x01, 0x01, 0x01, 0x05, 0x03, 0x01, 0x00, 0x02, 0x06, 0x08, 0x01, 0x7f,
      0x01, 0x41, 0x80, 0x88, 0x04, 0x0b, 0x07, 0x13, 0x02, 0x06, 0x6d, 0x65,
      0x6d, 0x6f, 0x72, 0x79, 0x02, 0x00, 0x06, 0x73, 0x71, 0x75, 0x61, 0x72,
      0x65, 0x00, 0x00, 0x0a, 0x09, 0x01, 0x07, 0x00, 0x20, 0x00, 0x20, 0x00,
      0x7e, 0x0b,
    ]);

    final mod = WasmModule(data);
    final serialized = mod.serialize();

    final inst = WasmModule.deserialize(serialized).builder().build();
    final fn = inst.lookupFunction('square');
    final n = fn(1234) as int;
    expect(n, 1234 * 1234);
  });

  // TODO(GH-70): Fix and re-enable.
  /*test('deserializing module from file', () {
    // int64_t square(int64_t n) { return n * n; }
    final serialized = File('test/test_files/serialized').readAsBytesSync();
    final inst = WasmModule.deserialize(serialized).builder().build();
    final fn = inst.lookupFunction('square');
    final n = fn(1234) as int;
    expect(n, 1234 * 1234);
  });*/
}
