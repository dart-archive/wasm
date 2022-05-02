// Copyright (c) 2021, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// Builds the wasmer runtime library for iOS, as a static framework.
// Usage: flutter pub run flutter_wasm:ios_setup path/to/output/directory

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:wasm/src/shared.dart';

final thisDir = path.dirname(Platform.script.path);
const inputLibName = 'libwasmer.dylib';
const outputLibName = 'flutter_wasm';
const archiveName = 'flutter_wasm_archive';

class Abi {
  final String triple;
  Abi(this.triple);
}

class IOSSdk {
  final String xcodeName;
  final List<Abi> abis;
  IOSSdk(this.xcodeName, this.abis);

  Future<String> findTool(String tool) async {
    return await _xcrun(['--sdk', xcodeName, '--find', tool]);
  }

  Future<String> findSdk() async {
    return await _xcrun(['--sdk', xcodeName, '--show-sdk-path']);
  }
}

final List<IOSSdk> iOSSdks = [
  /*IOSSdk('iphoneos', [
    // Abi('armv7-apple-ios'),
    Abi('aarch64-apple-ios'),
  ]),*/
  IOSSdk('iphonesimulator', [
    //Abi('aarch64-apple-ios-sim'),
    Abi('x86_64-apple-ios'),
  ]),
];

Future<void> checkResult(Process process) async {
  final result = await process.exitCode;
  if (result != 0) {
    exitCode = result;
    throw Exception('Build failed. Scroll up for the logs.');
  }
}

Future<void> _run(String program, List<String> args) async {
  print('FFFFF: ${Platform.script.path}');
  print('$program ${args.join(' ')}');
  final process = await Process.start(
    program,
    args,
    workingDirectory: thisDir,
  );
  unawaited(stderr.addStream(process.stderr));
  unawaited(stdout.addStream(process.stdout));
  await checkResult(process);
}

void copyDirectory(String from, String to) {
  for (final f in Directory(from).listSync(recursive: true)) {
    if (f is File) {
      final toPath = path.join(to, path.relative(f.path, from: from));
      Directory(path.dirname(toPath)).createSync(recursive: true);
      f.copySync(toPath);
    }
  }
}

Future<String> _xcrun(List<String> args) async {
  final process = await Process.start(
    'xcrun',
    args
  );
  unawaited(stderr.addStream(process.stderr));
  final out = await process.stdout
        .transform(utf8.decoder)
        .transform(LineSplitter())
        .firstWhere((line) => line.isNotEmpty);
  await checkResult(process);
  return out;
}

Future<void> main(List<String> args) async {
  await _run('flutter', ['pub', 'get']);

  final outDir = Directory(args[0]);
  print('Output directory: ${outDir.path}');
  print('This directory: $thisDir');

  if (!outDir.existsSync()) {
    await outDir.create(recursive: true);
  }

  final tempFrameworks = <String>[];
  for (final iOSSdk in iOSSdks) {
    final sdkOutDir = path.join(thisDir, 'ios/build/${iOSSdk.xcodeName}');
    // final frameworkTemplatePath = path.join(thisDir, 'ios/FrameworkTemplate');

    // HACK
    final frameworkTemplatePath = '/Users/liama/dev/wasm/flutter_wasm/ios/FrameworkTemplate';
    print('zzzzzzz: $frameworkTemplatePath');

    final libs = <String>[];
    final sdkPath = await iOSSdk.findSdk();
    final clangPath = await iOSSdk.findTool('clang');
    final clangppPath = await iOSSdk.findTool('clang++');
    final lipoPath = await iOSSdk.findTool('lipo');
    final arPath = await iOSSdk.findTool('ar');
    for (final abi in iOSSdk.abis) {
      final abiOutDir = Directory(path.join(sdkOutDir, abi.triple));
      print('Building for ${abi.triple} in $abiOutDir');
      if (!abiOutDir.existsSync()) {
        await abiOutDir.create(recursive: true);
      }
      // await _run('flutter', [
      //   'pub',
      //   'run',
      //   'wasm:setup',
      //   '-t',
      //   abi.triple,
      //   '-o',
      //   abiOutDir.path,
      //   '--clang',
      //   clangPath,
      //   '--clangpp',
      //   clangppPath,
      //   '--ar',
      //   arPath,
      //   '--sysroot',
      //   sdkPath,
      // ]);

      // HACK
      File('/Users/liama/libwasmer.dylib').copySync('/Users/liama/dev/wasm/flutter_wasm/example/.dart_tool/pub/bin/flutter_wasm/ios/build/iphonesimulator/x86_64-apple-ios/libwasmer.dylib');

      libs.add(path.join(abiOutDir.path, inputLibName));
    }
    final fatLibPath = path.join(sdkOutDir, outputLibName);
    print('Creating fat library for ${iOSSdk.xcodeName} at $fatLibPath');
    await _run(lipoPath, ['-create', ...libs, '-output', fatLibPath]);
    // final archivePath = sdkOutDir.resolve(archiveName).toFilePath();
    // await _run(xcodebuildPath, [
    //   'archive', '-scheme', 'WhatIsAScheme',
    //   '-library', fatLibPath,
    //   '-destination', 'generic/platform=${iOSSdk.xcodeName}',
    //   '-archivePath', archivePath
    //   ]);
    final tempFrameworkPath = path.join(sdkOutDir, 'lib_wasm.framework');
    copyDirectory(frameworkTemplatePath, tempFrameworkPath);
    File(fatLibPath).copySync(path.join(tempFrameworkPath, 'lib_wasm'));
    tempFrameworks.add(tempFrameworkPath);
  }
  final frameworkPath =
      path.join(outDir.path, 'Frameworks/flutter_wasm.xcframework');
  final frameworkDir = Directory(frameworkPath);
  if (await frameworkDir.exists()) {
    await frameworkDir.delete(recursive: true);
  }
  print('Creating framework at $frameworkPath');
  await _run('xcrun', [
    'xcodebuild',
    '-create-xcframework',
    for (final temp in tempFrameworks) ...['-framework', temp],
    '-output',
    frameworkPath,
  ]);
}
