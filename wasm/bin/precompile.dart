// Copyright (c) 2021, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// Precompiles and serializes a wasm module, so that it can be deserialized at
// runtime using WasmModule.deserialize. This skips doing the compilation at
// runtime, decreasing startup times.
// Usage: dart run wasm:precompile wasm_module.wasm -o serialized

import 'dart:io';

import 'package:args/args.dart';
import 'package:wasm/wasm.dart';

int main(List<String> arguments) {
  final parser = ArgParser()
    ..addOption(
      'out',
      abbr: 'o',
      help: 'Output file.',
    )
    ..addFlag(
      'help',
      abbr: 'h',
      negatable: false,
      help: 'Show this help.',
    );
  final args = parser.parse(arguments);

  if (args['help'] as bool) {
    print('Usage: dart run wasm:precompile wasm_module.wasm -o serialized\n');
    print(parser.usage);
    return 0;
  }

  if (args.rest.isEmpty) {
    print('No input file.');
    return 1;
  }

  final inFile = args.rest[0];
  final outFile = args['out'] as String?;
  if (outFile == null) {
    print('No output file.');
    return 1;
  }

  final inBytes = File(inFile).readAsBytesSync();
  final mod = WasmModule(inBytes);
  print('$inFile compiled successfully');

  print('\n=== Wasm module info ===');
  print(mod.describe());

  final outBytes = mod.serialize();
  File(outFile).writeAsBytesSync(outBytes);
  print('$outFile written successfully');
  return 0;
}
