// Copyright (c) 2020, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// Error specific to unexpected behavior or incorrect usage of this package.
///
/// Users of this type may not implement, mix-in or extend this type.
abstract class WasmError implements Error {
  /// Describes the nature of the error.
  String get message;
}

/// Exception that wraps exceptions (traps) thrown inside wasm code.
///
/// Users of this type may not implement, mix-in or extend this type.
abstract class WasmException implements Exception {
  /// Describes the nature of the exception.
  String get message;
}
