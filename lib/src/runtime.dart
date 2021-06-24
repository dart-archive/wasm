// Copyright (c) 2020, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';

import 'package:ffi/ffi.dart';

import 'shared.dart';
import 'wasm_error.dart';
import 'wasmer_api.dart';

part 'runtime.g.dart';

/// The singleton instance of [WasmRuntime].
final runtime = WasmRuntime._init();

_getImportExportString(int kind, String name, Pointer type) {
  final kindName = wasmerExternKindName(kind);
  if (kind == wasmerExternKindFunction) {
    final funcType = type as Pointer<WasmerFunctype>;
    final sig = getSignatureString(
      name,
      runtime.getArgTypes(funcType),
      runtime.getReturnType(funcType),
    );
    return '$kindName: $sig';
  } else if (kind == wasmerExternKindGlobal) {
    final globalType = type as Pointer<WasmerGlobaltype>;
    final typeName = wasmerValKindName(runtime.getContentType(globalType));
    return '$kindName: $typeName $name';
  } else {
    return '$kindName: $name';
  }
}

class WasmImportDescriptor {
  final int kind;
  final String moduleName;
  final String name;
  final Pointer type;

  WasmImportDescriptor._(this.kind, this.moduleName, this.name, this.type);

  @override
  String toString() => _getImportExportString(kind, '$moduleName::$name', type);
}

class WasmExportDescriptor {
  final int kind;
  final String name;
  final Pointer type;

  WasmExportDescriptor._(this.kind, this.name, this.type);

  @override
  String toString() => _getImportExportString(kind, name, type);
}

class _WasmTrapsEntry {
  final Object exception;

  _WasmTrapsEntry(this.exception);
}

class _WasiStreamIterator implements Iterator<List<int>> {
  static const int _bufferLength = 1024;
  final Pointer<Uint8> _buf = calloc<Uint8>(_bufferLength);
  final Pointer<WasmerWasiEnv> _env;
  final Function _reader;
  int _length = 0;

  _WasiStreamIterator(this._env, this._reader);

  @override
  bool moveNext() {
    _length = _reader(_env, _buf, _bufferLength) as int;
    return _length >= 0;
  }

  @override
  List<int> get current => _buf.asTypedList(_length);
}

class _WasiStreamIterable extends Iterable<List<int>> {
  final Pointer<WasmerWasiEnv> _env;
  final Function _reader;

  _WasiStreamIterable(this._env, this._reader);

  @override
  Iterator<List<int>> get iterator => _WasiStreamIterator(_env, _reader);
}

String _getLibName() {
  if (Platform.isMacOS) return appleLib;
  if (Platform.isLinux) return linuxLib;
  if (Platform.isWindows) return windowsLib;
  // TODO(dartbug.com/37882): Support more platforms.
  throw WasmError('Wasm not currently supported on this platform');
}

String? _getLibPathFrom(Uri root) {
  final pkgRoot = packageRootUri(root);

  return pkgRoot?.resolve('$wasmToolDir${_getLibName()}').toFilePath();
}

String _getLibPath() {
  var path = _getLibPathFrom(Platform.script.resolve('./'));
  if (path != null) return path;
  path = _getLibPathFrom(Directory.current.uri);
  if (path != null) return path;
  throw WasmError('Wasm library not found. Did you `$invocationString`?');
}

String getSignatureString(
  String name,
  List<int> argTypes,
  int returnType,
) =>
    '${wasmerValKindName(returnType)} '
    '$name(${argTypes.map(wasmerValKindName).join(', ')})';
