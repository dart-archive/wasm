// Copyright (c) 2020, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// Below is the DSL that models the information needed to
/// generate bindings to WASM modules.
///
/// It can be provided by a module that understands the
/// wasm binary format such as Wasmer or potentially a
/// custom parser.
library _;

/// Represents the top level information needed to generate bindings.
class WasmInfo {
  /// All imports.
  final List<WasmFn> imports;

  /// All exports.
  final List<WasmFn> exports;

  /// The name of the module.
  final String moduleName;

  const WasmInfo({
    required this.imports,
    required this.exports,
    required this.moduleName,
  });
}

/// Represents a WASM function.
class WasmFn {
  /// Represents the type that the function returns.
  final WasmType resultType;

  /// Represents the parameters in the function.
  final List<WasmType> params;

  /// Represents the name of the function.
  final String name;

  const WasmFn({
    required this.resultType,
    required this.params,
    required this.name,
  });
}

/// A parameter in a WASM function signature.
class WasmParam {
  /// The WASM type of the parameter.
  final WasmType type;

  const WasmParam({
    required this.type,
  });
}

/// Represents a wasm type.
enum WasmType {
  /// Represents the 'void' type in WASM.
  unit,

  /// Represents the 'int32' type in WASM.
  int32,

  /// Represents a type in WASM that is unknown.
  ///
  /// This case is here for forwards compatibility reasons.
  /// any actual occurrence of this value is a bug.
  unknown,
}
