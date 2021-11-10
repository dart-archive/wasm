// Copyright (c) 2021, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// Wrapper around wasm:setup, to work around the restriction that pub isn't
// allowed to directly run scripts owned by transient dependencies.

// Builds the wasmer runtime library, to by used by package:wasm.
// Usage: flutter pub run flutter_wasm:setup
// For more details use the --help option.

import 'dart:io';

Future<void> main(List<String> arguments) async {
  final workingDirectory = Uri.file(Platform.script.path).resolve('..');
  final process = await Process.start(
      'flutter',
      [
        'pub',
        'run',
        'wasm:setup',
        ...arguments,
      ],
      workingDirectory: workingDirectory.toFilePath());
  stdout.addStream(process.stdout);
  stderr.addStream(process.stderr);
  exitCode = await process.exitCode;
}
