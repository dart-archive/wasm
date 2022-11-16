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
import 'wasm_api.dart';
import 'wasmer_api.dart';

part 'runtime.g.dart';

/// The singleton instance of [WasmRuntime].
final runtime = WasmRuntime._init();

String _getImportExportString(int kind, String name, Pointer type) {
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
    final typeName = wasmerValKindName(runtime.getGlobalKind(globalType));
    final mutName = wasmerMutabilityName(runtime.getGlobalMut(globalType));
    return '$kindName: $mutName $typeName $name';
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
  if (Platform.isLinux || Platform.isAndroid) return linuxLib;
  if (Platform.isWindows) return windowsLib;
  // TODO(dartbug.com/37882): Support more platforms.
  throw _WasmRuntimeErrorImpl('Wasm not currently supported on this platform');
}

String? _getLibPathFrom(Uri root) {
  final pkgRoot = packageRootUri(root);
  return pkgRoot?.resolve('$wasmToolDir${_getLibName()}').toFilePath();
}

String _getLibPath() {
  if (Platform.isAndroid) return _getLibName();
  var path = _getLibPathFrom(Platform.script.resolve('./'));
  if (path != null) return path;
  path = _getLibPathFrom(Directory.current.uri);
  if (path != null) return path;
  throw _WasmRuntimeErrorImpl(
    'Wasm library not found. Did you `$invocationString`?',
  );
}

DynamicLibrary _loadDynamicLib() {
  return Platform.isIOS
      ? DynamicLibrary.process()
      : DynamicLibrary.open(_getLibPath());
}

String getSignatureString(
  String name,
  List<int> argTypes,
  int returnType,
) =>
    '${wasmerValKindName(returnType)} '
    '$name(${argTypes.map(wasmerValKindName).join(', ')})';

class _WasmRuntimeErrorImpl extends Error implements WasmError {
  @override
  final String message;

  _WasmRuntimeErrorImpl(
    this.message,
  ) : assert(message.trim() == message);

  @override
  String toString() => 'WasmRuntimeError: $message';
}

class _WasmRuntimeExceptionImpl implements WasmException {
  @override
  final String message;

  const _WasmRuntimeExceptionImpl(
    this.message,
  );

  @override
  String toString() => 'WasmRuntimeException: $message';
}
