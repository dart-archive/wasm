// Copyright (c) 2020, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:io';

const invocationString = 'dart run wasm:setup';

const pkgConfigFile = '.dart_tool/package_config.json';
const wasmToolDir = '.dart_tool/wasm/';

const appleLib = 'libwasmer.dylib';
const linuxLib = 'libwasmer.so';
const windowsLib = 'wasmer.dll';

Uri? packageRootUri(Uri root) {
  do {
    if (FileSystemEntity.isFileSync(root.resolve(pkgConfigFile).toFilePath())) {
      return root;
    }
  } while (root != (root = root.resolve('..')));
  return null;
}

Uri libBuildOutDir(Uri root) {
  final pkgRoot = packageRootUri(root);
  if (pkgRoot == null) {
    throw ArgumentError('Could not find "$pkgConfigFile" within "$root".');
  }
  return pkgRoot.resolve(wasmToolDir);
}
