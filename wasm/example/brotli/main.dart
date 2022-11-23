// Copyright (c) 2021, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// Example of using package:wasm to run a wasm build of the Brotli compression
// library. Usage:
// dart main.dart input.txt

import 'dart:io';

import 'brotli_api.dart';

void main(List<String> args) {
  if (args.length != 1) {
    print('Requires one argument: a path to the input file.');
    exitCode = 64; // bad usage
    return;
  }

  final inputFilePath = args.single;

  print('Loading "$inputFilePath"...');
  final inputDataFile = File(inputFilePath);
  if (!inputDataFile.existsSync()) {
    print('Input file "$inputFilePath" does not exist.');
    exitCode = 66; // no input file
    return;
  }

  final inputData = inputDataFile.readAsBytesSync();
  print('Input size: ${inputData.length} bytes');

  print('\nLoading wasm module');
  final brotliPath = Platform.script.resolve('libbrotli.wasm');
  final moduleData = File(brotliPath.toFilePath()).readAsBytesSync();
  final brotli = Brotli(moduleData);

  print('\nCompressing...');
  final output = brotli.compress(inputData);

  final compressedSize = output.length;
  print('Compressed size: $compressedSize bytes');
  final spaceSaving = 100 * (1 - compressedSize / inputData.length);
  print('Space saving: ${spaceSaving.toStringAsFixed(2)}%');

  print('\nDecompressing...');
  final decompressed = brotli.decompress(output, inputData.length);

  final decompressedSize = decompressed.length;
  print('Decompressed size: $decompressedSize bytes');

  print('\nVerifying decompression...');
  assert(inputData.length == decompressedSize);
  for (var i = 0; i < inputData.length; ++i) {
    assert(inputData[i] == decompressed[i]);
  }
  print('Decompression succeeded :)');
}
