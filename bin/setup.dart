// Copyright (c) 2021, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// Builds the wasmer runtime library, to by used by package:wasm. Requires
// rustc, cargo, clang, and clang++. If a target triple is not specified, it
// will default to the host target.
// Usage: dart run wasm:setup [target-triple]

import 'dart:convert';
import 'dart:io' hide exit;

import 'package:wasm/src/shared.dart';

Future<void> main(List<String> args) async {
  if (args.length > 1) {
    print('Usage: $invocationString [target-triple]');
    exitCode = 64; // bad usage
    return;
  }

  final target = args.isNotEmpty ? args[0] : await _getTargetTriple();

  try {
    await _main(target);
  } on ProcessException catch (e, stack) {
    print('FAILED with exit code ${e.errorCode}');
    print(stack);
    exitCode = 70; // software error
    return;
  }
}

Uri _getSdkDir() {
  // The common case, and how cli_util.dart computes the Dart SDK directory,
  // path.dirname called twice on Platform.resolvedExecutable.
  final exe = Uri.file(Platform.resolvedExecutable);
  final commonSdkDir = exe.resolve('../../dart-sdk/');
  if (FileSystemEntity.isDirectorySync(commonSdkDir.path)) {
    return commonSdkDir;
  }

  // This is the less common case where the user is in the checked out Dart
  // SDK, and is executing dart via:
  // ./out/ReleaseX64/dart ...
  final checkedOutSdkDir = exe.resolve('../dart-sdk/');
  if (FileSystemEntity.isDirectorySync(checkedOutSdkDir.path)) {
    return checkedOutSdkDir;
  }

  final homebrewOutSdkDir = exe.resolve('..');
  final homebrewIncludeDir = homebrewOutSdkDir.resolve('include');
  if (FileSystemEntity.isDirectorySync(homebrewIncludeDir.path)) {
    return homebrewOutSdkDir;
  }

  // If neither returned above, we return the common case:
  return commonSdkDir;
}

Uri _getSdkIncDir(Uri sdkDir) {
  var sdkIncDir = sdkDir.resolve('include/');
  if (File.fromUri(sdkIncDir.resolve('dart_api.h')).existsSync()) {
    return sdkIncDir;
  }
  // Flutter's Dart SDK puts the API headers in a different directory.
  sdkIncDir = sdkDir.resolve('include/third_party/dart/');
  if (File.fromUri(sdkIncDir.resolve('dart_api.h')).existsSync()) {
    return sdkIncDir;
  }
  throw FileSystemException(
    "Can't find the include directory in the Dart SDK",
    sdkDir.path,
  );
}

File _findDartApiDlImpl(Uri sdkIncDir) {
  var file = File.fromUri(sdkIncDir.resolve('internal/dart_api_dl_impl.h'));
  if (file.existsSync()) return file;
  // In some versions of the Dart SDK, this header was in a different directory.
  file = File.fromUri(sdkIncDir.resolve('runtime/dart_api_dl_impl.h'));
  if (file.existsSync()) return file;
  throw FileSystemException(
    "Can't find dart_api_dl_impl.h in the Dart SDK include directory",
    sdkIncDir.path,
  );
}

Uri _outputDir() {
  final root = Directory.current.uri;
  final pkgRoot = packageRootUri(root);
  if (pkgRoot == null) {
    throw ArgumentError('Could not find "$pkgConfigFile" within "$root".');
  }
  return pkgRoot.resolve(wasmToolDir);
}

String _getOutLib(String target) {
  final os = RegExp(r'^.*-.*-(.*)').firstMatch(target)?.group(1) ?? '';
  if (os == 'darwin' || os == 'ios') {
    return appleLib;
  } else if (os == 'windows') {
    return 'wasmer.dll';
  }
  return linuxLib;
}

Future<String> _getTargetTriple() async {
  final _regexp = RegExp(r'^([^=]+)="(.*)"$');
  final process = await Process.start('rustc', ['--print', 'cfg']);
  final sub = process.stderr
      .transform(utf8.decoder)
      .transform(const LineSplitter())
      .listen((line) => stderr.writeln(line));
  final cfg = <String, String?>{};
  await process.stdout
      .transform(utf8.decoder)
      .transform(const LineSplitter())
      .forEach((line) {
    final match = _regexp.firstMatch(line);
    if (match != null) cfg[match.group(1)!] = match.group(2);
  });
  await sub.cancel();
  var arch = cfg['target_arch'] ?? 'unknown';
  var vendor = cfg['target_vendor'] ?? 'unknown';
  var os = cfg['target_os'] ?? 'unknown';
  if (os == 'macos') os = 'darwin';
  var env = cfg['target_env'];
  return [arch, vendor, os, env]
      .where((element) => element != null && element.isNotEmpty)
      .join('-');
}

Future<void> _run(String exe, List<String> args) async {
  print('\n$exe ${args.join(' ')}\n');

  Future<void> capture(Stream<List<int>> std) => std
      .transform(systemEncoding.decoder)
      .transform(const LineSplitter())
      .forEach(print);

  final process = await Process.start(exe, args);

  await Future.wait([capture(process.stdout), capture(process.stderr)]);

  final result = await process.exitCode;
  if (result != 0) {
    throw ProcessException(exe, args, '', result);
  }
}

Future<void> _main(String target) async {
  final sdkDir = _getSdkDir();
  final sdkIncDir = _getSdkIncDir(sdkDir);
  final binDir = Platform.script;
  final outDir = _outputDir();
  final outLib = outDir.resolve(_getOutLib(target)).toFilePath();

  print('Dart SDK directory: ${sdkDir.toFilePath()}');
  print('Dart SDK include directory: ${sdkIncDir.toFilePath()}');
  print('Script directory: ${binDir.toFilePath()}');
  print('Output directory: ${outDir.toFilePath()}');
  print('Target: $target');
  print('Output library: $outLib');

  // Build wasmer crate.
  await _run('cargo', [
    'build',
    '--target',
    target,
    '--target-dir',
    outDir.toFilePath(),
    '--manifest-path',
    binDir.resolve('Cargo.toml').toFilePath(),
    '--release'
  ]);

  // Hack around a bug with dart_api_dl_impl.h include path in dart_api_dl.c.
  const dartApiDlImplPath = 'include/internal/dart_api_dl_impl.h';
  if (!File.fromUri(sdkIncDir.resolve(dartApiDlImplPath)).existsSync()) {
    Directory(outDir.resolve('include/internal/').toFilePath())
        .createSync(recursive: true);
    await _findDartApiDlImpl(sdkIncDir)
        .copy(outDir.resolve(dartApiDlImplPath).toFilePath());
  }

  // Build dart_api_dl.o.
  await _run('clang', [
    '-DDART_SHARED_LIB',
    '-DNDEBUG',
    '-fno-exceptions',
    '-fPIC',
    '-O3',
    '-target',
    target,
    '-I',
    sdkIncDir.toFilePath(),
    '-I',
    outDir.resolve('include/').toFilePath(),
    '-c',
    sdkIncDir.resolve('dart_api_dl.c').toFilePath(),
    '-o',
    outDir.resolve('dart_api_dl.o').toFilePath()
  ]);

  // Build finalizers.o.
  await _run('clang++', [
    '-DDART_SHARED_LIB',
    '-DNDEBUG',
    '-fno-exceptions',
    '-fno-rtti',
    '-fPIC',
    '-O3',
    '-std=c++11',
    '-target',
    target,
    '-I',
    sdkIncDir.toFilePath(),
    '-I',
    outDir.resolve('include/').toFilePath(),
    '-c',
    binDir.resolve('finalizers.cc').toFilePath(),
    '-o',
    outDir.resolve('finalizers.o').toFilePath()
  ]);

  // Link wasmer, dart_api_dl, and finalizers to create the output library.
  await _run('clang++', [
    '-shared',
    '-fPIC',
    '-target',
    target,
    outDir.resolve('dart_api_dl.o').toFilePath(),
    outDir.resolve('finalizers.o').toFilePath(),
    outDir.resolve('$target/release/libwasmer.a').toFilePath(),
    '-o',
    outLib
  ]);
}
