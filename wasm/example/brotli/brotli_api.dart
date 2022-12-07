// Copyright (c) 2022, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:typed_data';

import 'package:wasm/wasm.dart';

class Brotli {
  late final WasmInstance _instance;
  late final WasmMemory _memory;
  late final dynamic _compress;
  late final dynamic _decompress;
  late final int _initMemBytes;

  // Brotli compression parameters.
  static const _kDefaultQuality = 11;
  static const _kDefaultWindow = 22;
  static const _kDefaultMode = 0;

  /// Construct a Brotli compressor.
  Brotli(Uint8List brotliWasmModuleData) {
    final module = wasmModuleCompileSync(brotliWasmModuleData);
    final builder = module.builder()..enableWasi();
    _instance = builder.build();
    _memory = _instance.memory;
    _compress = _instance.lookupFunction('BrotliEncoderCompress');
    _decompress = _instance.lookupFunction('BrotliDecoderDecompress');
    _initMemBytes = _memory.lengthInBytes;
  }

  /// Compresses the input data.
  ///
  /// WARNING: The returned buffer is owned by wasm. It will be invalidated by
  /// any further compress or decompress calls. So make a copy if you need the
  /// data to last longer than that.
  Uint8List compress(Uint8List input) => _runBrotli(
        input,
        input.length,
        (int inputPtr, int outputSizePtr, int outputPtr) => _compress(
          _kDefaultQuality,
          _kDefaultWindow,
          _kDefaultMode,
          input.length,
          inputPtr,
          outputSizePtr,
          outputPtr,
        ) as int,
      );

  /// Decompresses the input data.
  ///
  /// maxDecompressedSize should overestimate the expected decompressed size.
  ///
  /// WARNING: The returned buffer is owned by wasm. It will be invalidated by
  /// any further compress or decompress calls. So make a copy if you need the
  /// data to last longer than that.
  Uint8List decompress(Uint8List input, int maxDecompressedSize) => _runBrotli(
        input,
        maxDecompressedSize,
        (int inputPtr, int outputSizePtr, int outputPtr) => _decompress(
          input.length,
          inputPtr,
          outputSizePtr,
          outputPtr,
        ) as int,
      );

  Uint8List _runBrotli(
    Uint8List input,
    int maxOutputSize,
    int Function(int, int, int) impl,
  ) {
    // Ensure the wasm memory has enough space for our data.
    // Memory layout: [initial memory][input data][output data][size]
    final requiredBytes = _initMemBytes + input.length + maxOutputSize + 4;
    final deltaBytes = requiredBytes - _memory.lengthInBytes;
    if (deltaBytes > 0) {
      final deltaPages = (deltaBytes / WasmMemory.kPageSizeInBytes).ceil();
      _memory.grow(deltaPages);
    }
    final view = _memory.view;
    final inputPtr = _initMemBytes;
    final outputPtr = inputPtr + input.length;
    final outSizePtr = outputPtr + maxOutputSize;

    // Load the input into wasm memory.
    view.setRange(inputPtr, inputPtr + input.length, input);

    // Load the output buffer size into wasm memory.
    final sizeBytes = ByteData(4)..setUint32(0, maxOutputSize, Endian.host);
    view.setRange(outSizePtr, outSizePtr + 4, sizeBytes.buffer.asUint8List());

    // Call brotli.
    final status = impl(inputPtr, outSizePtr, outputPtr);
    if (status == 0) {
      throw Exception('Brotli failed');
    }

    // Return the output buffer.
    final outSize = ByteData.sublistView(view, outSizePtr, outSizePtr + 4)
        .getUint32(0, Endian.host);
    return Uint8List.sublistView(view, outputPtr, outputPtr + outSize);
  }
}
