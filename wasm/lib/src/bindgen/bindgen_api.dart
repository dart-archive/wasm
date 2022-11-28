// Copyright (c) 2020, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// Below are the interfaces that generated code will depend on.
library _;

/// An interface used for invoking wasm functions.
abstract class BindingInstance {
  /// Generated bindings will invoke this method
  /// when they intend to invoke a function on in
  /// a wasm module.
  void invokeFunction(
    String name,
    List<dynamic> arguments,
  );
}

/// An interface used for specifying wasm imports.
abstract class BindingBuilder {
  /// Generated bindings will invoke this method
  /// when they intend to add imports to a wasm module.
  void addImport(
    String module,
    String name,
    Function fn,
  );
}
