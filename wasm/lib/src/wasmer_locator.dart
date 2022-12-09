// Copyright (c) 2020, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:ffi';
import 'dart:io';

/// Attempts to locate the Wasmer dynamic library.
///
/// Throws [WasmLocatorError] if the dynamic library could not be found.
DynamicLibrary loadWasmerDynamicLibrary() {
  String locate(String libName) {
    final dir = '$_wasmToolDir$libName';
    final value = _packageRootUri(Platform.script.resolve('./')) ??
        _packageRootUri(Directory.current.uri);
    if (value != null) {
      return value.resolve(dir).toFilePath();
    } else {
      throw WasmLocatorError(
        'Wasm library not found. Did you run `$invocationString`?',
      );
    }
  }

  if (Platform.isIOS) {
    return DynamicLibrary.process();
  } else if (Platform.isMacOS) {
    return DynamicLibrary.open(locate(appleLib));
  } else if (Platform.isWindows) {
    return DynamicLibrary.open(locate(windowsLib));
  } else if (Platform.isLinux) {
    return DynamicLibrary.open(locate(linuxLib));
  } else if (Platform.isAndroid) {
    return DynamicLibrary.open(linuxLib);
  } else if (Platform.isFuchsia) {
    throw WasmLocatorError(
      'Wasm is currently not supported on Fuchsia.',
    );
  } else {
    throw WasmLocatorError(
      'Wasm is currently not supported on this platform.',
    );
  }
}

/// This error is thrown when the dynamic library could not be found.
class WasmLocatorError extends Error {
  final String message;

  WasmLocatorError(
    this.message,
  );

  @override
  String toString() => 'WasmLocatorError: $message';
}

/// The command that can be used to set up this package.
const invocationString = 'dart run wasm:setup';

/// The expected name of the Wasmer library when compiled for Apple devices.
const appleLib = 'libwasmer.dylib';

/// The expected name of the Wasmer library when compiled for Linux devices.
const linuxLib = 'libwasmer.so';

/// The expected name of the Wasmer library when compiled for Windows devices.
const windowsLib = 'wasmer.dll';

/// Returns the uri representing the target output directory of generated
/// dynamic libraries.
Uri libBuildOutDir(Uri root) {
  final pkgRoot = _packageRootUri(root);
  if (pkgRoot == null) {
    throw ArgumentError('Could not find "$_pkgConfigFile" within "$root".');
  }
  return pkgRoot.resolve(_wasmToolDir);
}

const _wasmToolDir = '.dart_tool/wasm/';

const _pkgConfigFile = '.dart_tool/package_config.json';

Uri? _packageRootUri(Uri root) {
  do {
    if (FileSystemEntity.isFileSync(
      root.resolve(_pkgConfigFile).toFilePath(),
    )) {
      return root;
    }
  } while (root != (root = root.resolve('..')));
  return null;
}
