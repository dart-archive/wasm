// Copyright (c) 2021, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// Wrapper around wasm:setup, to work around the restriction that pub isn't
// allowed to directly run scripts owned by transient dependencies.

// Builds the wasmer runtime library, to by used by package:wasm.
// Usage: flutter pub run flutter_wasm:setup
// For more details use the --help option.

import 'dart:async';
import 'dart:io';

import 'package:wasm/src/shared.dart';

final workingDirectory = Uri.file(Platform.script.path).resolve('..');

Future<int> _runFlutter(List<String> args) async {
  print('flutter ${args.join(' ')}');
  final process = await Process.start(
    'flutter',
    args,
    workingDirectory: workingDirectory.toFilePath(),
  );
  unawaited(stdout.addStream(process.stdout));
  unawaited(stderr.addStream(process.stderr));
  return process.exitCode;
}

Future<void> main(List<String> args) async {
  final outDir = libBuildOutDir(Directory.current.uri).toFilePath();
  exitCode = await _runFlutter(['pub', 'get']);
  if (exitCode != 0) return;
  exitCode =
      await _runFlutter(['pub', 'run', 'wasm:setup', '-o', outDir, ...args]);
}
