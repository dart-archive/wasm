// Copyright (c) 2021, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// Builds the wasmer runtime library for iOS, as a static framework.
// Usage: flutter pub run flutter_wasm:ios_setup path/to/output/directory

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:wasm/src/shared.dart';

final workingDirectory = Uri.file(Platform.script.path).resolve('..');
const inputLibName = 'libwasmer.dylib';
const outputLibName = 'libflutter_wasm.dylib';

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
  print('$program ${args.join(' ')}');
  final process = await Process.start(
    program,
    args,
    workingDirectory: workingDirectory.toFilePath(),
  );
  unawaited(stderr.addStream(process.stderr));
  unawaited(stdout.addStream(process.stdout));
  await checkResult(process);
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
  print('Working directory: ${workingDirectory.toFilePath()}');

  if (!await outDir.exists()) {
    await outDir.create(recursive: true);
  }

  final fatLibs = <String>[];
  for (final iOSSdk in iOSSdks) {
    final sdkOutDir = workingDirectory.resolve('ios/build/${iOSSdk.xcodeName}');
    final libs = <String>[];
    final sdkPath = await iOSSdk.findSdk();
    final clangPath = await iOSSdk.findTool('clang');
    final clangppPath = await iOSSdk.findTool('clang++');
    final arPath = await iOSSdk.findTool('ar');
    for (final abi in iOSSdk.abis) {
      final abiOutDir = Directory.fromUri(sdkOutDir.resolve(abi.triple));
      print('Building for ${abi.triple} in $abiOutDir');
      if (!await abiOutDir.exists()) {
        await abiOutDir.create(recursive: true);
      }
      await _run('flutter', [
        'pub',
        'run',
        'wasm:setup',
        '-t',
        abi.triple,
        '-o',
        abiOutDir.path,
        '--clang',
        clangPath,
        '--clangpp',
        clangppPath,
        '--ar',
        arPath,
        '--sysroot',
        sdkPath,
      ]);
      libs.add(abiOutDir.uri.resolve(inputLibName).toFilePath());
    }
    final fatLibPath = sdkOutDir.resolve(outputLibName).toFilePath();
    print('Creating fat library for ${iOSSdk.xcodeName} at $fatLibPath');
    await _run('lipo', ['-create', ...libs, '-output', fatLibPath]);
    fatLibs.add(fatLibPath);
  }
  final frameworkPath =
      outDir.uri.resolve('Frameworks/flutter_wasm.xcframework').toFilePath();
  final frameworkDir = Directory(frameworkPath);
  if (await frameworkDir.exists()) {
    await frameworkDir.delete(recursive: true);
  }
  print('Creating framework at $frameworkPath');
  await _run('xcodebuild', [
    '-create-xcframework',
    for (final fatLib in fatLibs) ...['-library', fatLib],
    '-output',
    frameworkPath,
  ]);
}
