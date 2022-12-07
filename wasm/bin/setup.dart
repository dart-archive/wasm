// Copyright (c) 2021, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// Builds the wasmer runtime library, to by used by package:wasm. Requires
// Rust (rustc, rustup, cargo), and Clang (clang, clang++, ar).
// Usage: dart run wasm:setup
// For more details use the --help option.

import 'dart:convert';
import 'dart:io' hide exit;

import 'package:args/args.dart';
import 'package:package_config/package_config.dart' show findPackageConfig;
import 'package:wasm/src/wasmer_locator.dart';

Future<void> main(List<String> arguments) async {
  final parser = ArgParser()
    ..addOption(
      'target',
      abbr: 't',
      help: 'Target triple. Defaults to host target.',
    )
    ..addOption(
      'out-dir',
      abbr: 'o',
      help: 'Output directory. Defaults to the directory that package:wasm '
          'searches.',
    )
    ..addOption(
      'rustc',
      help: "Path of rustc. Defaults to assuming it's in PATH variable.",
    )
    ..addOption(
      'rustup',
      help: "Path of rustup. Defaults to assuming it's in PATH variable.",
    )
    ..addOption(
      'cargo',
      help: "Path of cargo. Defaults to assuming it's in PATH variable.",
    )
    ..addOption(
      'clang',
      help: "Path of clang. Defaults to assuming it's in PATH variable.",
    )
    ..addOption(
      'clangpp',
      help: "Path of clang++. Defaults to assuming it's in PATH variable.",
    )
    ..addOption(
      'ar',
      help: "Path of ar. Defaults to assuming it's in PATH variable.",
    )
    ..addOption(
      'sysroot',
      help: 'Sysroot argument passed to linker.',
    )
    ..addFlag(
      'help',
      abbr: 'h',
      negatable: false,
      help: 'Show this help.',
    );
  final args = parser.parse(arguments);

  if (args['help'] as bool) {
    print('Usage: $invocationString [OPTION...]\n');
    print(parser.usage);
    exitCode = 0; // ok
    return;
  }

  try {
    await _main(args);
  } on ProcessException catch (e) {
    final invocation = [e.executable, ...e.arguments].join(' ');
    print('FAILED with exit code ${e.errorCode} `$invocation`');
    exitCode = 70; // software error
    return;
  }
}

Uri _getSdkDir() {
  // The common case, and how cli_util.dart computes the Dart SDK directory,
  // path.dirname called twice on Platform.resolvedExecutable.
  final exe = Uri.file(Platform.resolvedExecutable);
  final commonSdkDir = exe.resolve('../../dart-sdk/');
  if (FileSystemEntity.isDirectorySync(commonSdkDir.toFilePath())) {
    return commonSdkDir;
  }

  // This is the less common case where the user is in the checked out Dart
  // SDK, and is executing dart via:
  // ./out/ReleaseX64/dart ...
  final checkedOutSdkDir = exe.resolve('../dart-sdk/');
  if (FileSystemEntity.isDirectorySync(checkedOutSdkDir.toFilePath())) {
    return checkedOutSdkDir;
  }

  final homebrewOutSdkDir = exe.resolve('..');
  final homebrewIncludeDir = homebrewOutSdkDir.resolve('include');
  if (FileSystemEntity.isDirectorySync(homebrewIncludeDir.toFilePath())) {
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
    sdkDir.toFilePath(),
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
    sdkIncDir.toFilePath(),
  );
}

Future<Uri> _getSrcDir() async {
  final srcDir = Platform.script.resolve('./');
  if (await File.fromUri(srcDir.resolve('setup.dart')).exists()) {
    // Typical case, where this script is being run from source, or was
    // precompiled into that directory.
    return srcDir;
  }
  // If the wasm is included as a git dependency, then pub can precompile this
  // script to a different directory. In that case, the only way to find where
  // the original script was located is by reading the package_config file.
  // See #17 for more info.
  final config = await findPackageConfig(Directory.fromUri(srcDir));
  if (config == null) {
    throw FileSystemException(
      "Can't find a package config file above this directory",
      srcDir.toFilePath(),
    );
  }
  for (final pkg in config.packages) {
    if (pkg.name == 'wasm') {
      return pkg.root.resolve('bin/');
    }
  }
  throw FileSystemException(
    "Can't find package:wasm in the package config file above this directory",
    srcDir.toFilePath(),
  );
}

String _getOsFromTarget(String target) =>
    RegExp('^[^-]*-[^-]*-([^-]*)').firstMatch(target)?.group(1) ?? '';

String _getOutLib(String os) {
  if (os == 'darwin' || os == 'ios') {
    return appleLib;
  } else if (os == 'windows') {
    return windowsLib;
  }
  return linuxLib;
}

String _getWasmerLib(String os) {
  if (os == 'windows') {
    return 'wasmer.lib';
  }
  return 'libwasmer.a';
}

Future<String> _getTargetTriple(String rustc) async {
  final regexp = RegExp(r'^([^=]+)="(.*)"$');
  final process = await Process.start(rustc, ['--print', 'cfg']);
  final sub = process.stderr
      .transform(utf8.decoder)
      .transform(const LineSplitter())
      .listen((line) => stderr.writeln(line));
  final cfg = <String, String?>{};
  await process.stdout
      .transform(utf8.decoder)
      .transform(const LineSplitter())
      .forEach((line) {
    final match = regexp.firstMatch(line);
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

Future<void> _run(
  String exe,
  List<String> args, {
  Uri? output,
  Map<String, String>? environment,
}) async {
  print('\n$exe ${args.join(' ')}\n');
  final process = await Process.start(
    exe,
    args,
    mode: ProcessStartMode.inheritStdio,
    environment: environment,
  );
  final result = await process.exitCode;
  if (result != 0) {
    throw ProcessException(exe, args, '', result);
  }
  if (output != null && !File.fromUri(output).existsSync()) {
    throw FileSystemException(
      'Command succeded, but the output file is missing',
      output.toFilePath(),
    );
  }
}

String _toUpperUnderscore(String string) =>
    string.toUpperCase().replaceAll('-', '_');

Future<void> _main(ArgResults args) async {
  final rustc = args['rustc'] as String? ?? 'rustc';
  final rustup = args['rustup'] as String? ?? 'rustup';
  final cargo = args['cargo'] as String? ?? 'cargo';
  final clang = args['clang'] as String? ?? 'clang';
  final clangpp = args['clangpp'] as String? ?? 'clang++';

  final target = args['target'] as String? ?? await _getTargetTriple(rustc);
  final sdkDir = _getSdkDir();
  final sdkIncDir = _getSdkIncDir(sdkDir);
  final srcDir = await _getSrcDir();
  final outDir = args['out-dir'] != null
      ? Uri.directory(args['out-dir'] as String)
      : libBuildOutDir(Directory.current.uri);
  final os = _getOsFromTarget(target);
  final outLib = outDir.resolve(_getOutLib(os));
  final outWasmer = outDir.resolve('$target/release/${_getWasmerLib(os)}');
  final outDartApi = outDir.resolve('dart_api_dl.o');
  final outFinalizers = outDir.resolve('finalizers.o');

  print('Dart SDK directory: ${sdkDir.toFilePath()}');
  print('Dart SDK include directory: ${sdkIncDir.toFilePath()}');
  print('Source directory: ${srcDir.toFilePath()}');
  print('Output directory: ${outDir.toFilePath()}');
  print('Target: $target');
  print('OS: $os');
  print('Output library: ${outLib.toFilePath()}');

  // Make sure rust libs are installed for the target.
  await _run(rustup, ['target', 'add', target]);

  // Build wasmer crate.
  await _run(
    cargo,
    [
      'build',
      '--target',
      target,
      '--target-dir',
      outDir.toFilePath(),
      '--manifest-path',
      srcDir.resolve('Cargo.toml').toFilePath(),
      '--release'
    ],
    output: outWasmer,
    environment: {
      if (args['clang'] != null) 'CC': clang,
      if (args['clangpp'] != null) ...{
        'CXX': clangpp,
        'LINKER': clangpp,
        'CARGO_TARGET_${_toUpperUnderscore(target)}_LINKER': clangpp,
      },
      if (args['ar'] != null) 'AR': args['ar'] as String,
    },
  );

  // Hack around a bug with dart_api_dl_impl.h include path in dart_api_dl.c.
  const dartApiDlImplPath = 'include/internal/dart_api_dl_impl.h';
  if (!File.fromUri(sdkIncDir.resolve(dartApiDlImplPath)).existsSync()) {
    Directory(outDir.resolve('include/internal/').toFilePath())
        .createSync(recursive: true);
    await _findDartApiDlImpl(sdkIncDir)
        .copy(outDir.resolve(dartApiDlImplPath).toFilePath());
  }

  // Build dart_api_dl.o.
  await _run(
    clang,
    [
      '-DDART_SHARED_LIB',
      '-DNDEBUG',
      '-fno-exceptions',
      if (os != 'windows') '-fPIC',
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
      outDartApi.toFilePath()
    ],
    output: outDartApi,
  );

  // Build finalizers.o.
  await _run(
    clang,
    [
      '-DDART_SHARED_LIB',
      '-DNDEBUG',
      '-fno-exceptions',
      if (os != 'windows') '-fPIC',
      '-O3',
      '-target',
      target,
      '-I',
      sdkIncDir.toFilePath(),
      '-I',
      outDir.resolve('include/').toFilePath(),
      '-c',
      srcDir.resolve('finalizers.c').toFilePath(),
      '-o',
      outFinalizers.toFilePath()
    ],
    output: outFinalizers,
  );

  // Link wasmer, dart_api_dl, and finalizers to create the output library.
  await _run(
    clang,
    [
      '-shared',
      if (args['sysroot'] != null) '--sysroot=${args['sysroot']}',
      if (os != 'windows') '-fPIC',
      if (os == 'windows') ...[
        '-lws2_32',
        '-ladvapi32',
        '-lbcrypt',
        '-luserenv',
        '-z',
        '/DEF:${srcDir.resolve('module.g.def').toFilePath()}',
        '-z',
        '/NODEFAULTLIB:MSVCRT',
      ],
      '-lm',
      '-target',
      target,
      outDartApi.toFilePath(),
      outFinalizers.toFilePath(),
      outWasmer.toFilePath(),
      '-o',
      outLib.toFilePath()
    ],
    output: outLib,
  );
}
