// Copyright (c) 2020, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:typed_data';

/// A compiled module that can be instantiated.
///
/// Users of this type may not implement, mix-in or extend this type.
abstract class WasmModule {
  /// Returns a [WasmInstanceBuilder] that is used to add all the imports that
  /// the module needs before instantiating it.
  WasmInstanceBuilder builder();

  /// Create a new memory with the given number of initial pages, and optional
  /// maximum number of pages.
  WasmMemory createMemory(
    int pages, [
    int? maxPages,
  ]);

  /// Returns a description of all of the module's imports and exports, for
  /// debugging.
  String describe();
}

/// Used to collect all of the imports that a [WasmModule] requires before it is
/// built.
///
/// Users of this type may not implement, mix-in or extend this type.
abstract class WasmInstanceBuilder {
  /// Add a WasmMemory to the imports.
  void addMemory(
    String moduleName,
    String name,
    WasmMemory memory,
  );

  /// Add a function to the imports.
  void addFunction(
    String moduleName,
    String name,
    Function fn,
  );

  /// Add a global to the imports.
  WasmGlobal addGlobal(
    String moduleName,
    String name,
    dynamic val,
  );

  /// Enable WASI and add the default WASI imports.
  void enableWasi({
    bool captureStdout,
    bool captureStderr,
  });

  /// Build the module instance.
  WasmInstance build();

  /// Asynchronously build the module instance.
  Future<WasmInstance> buildAsync();
}

/// An instantiated [WasmModule].
///
/// Created by calling [WasmInstanceBuilder.build].
///
/// Users of this type may not implement, mix-in or extend this type.
abstract class WasmInstance {
  /// Searches the instantiated module for the given function.
  ///
  /// Returns a [WasmFunction], but the return type is [dynamic] to allow
  /// easy invocation as a [Function].
  ///
  /// Returns `null` if no function exists with name [name].
  dynamic lookupFunction(
    String name,
  );

  /// Searches the instantiated module for the given global.
  ///
  /// Returns `null` if no global exists with name [name].
  WasmGlobal? lookupGlobal(
    String name,
  );

  /// Returns the memory exported from this instance.
  WasmMemory get memory;

  /// Returns a stream that reads from `stdout`.
  ///
  /// To use this, you must enable WASI when instantiating the module, and set
  /// `captureStdout` to `true`.
  Stream<List<int>> get stdout;

  /// Returns a stream that reads from `stderr`.
  ///
  /// To use this, you must enable WASI when instantiating the module, and set
  /// `captureStderr` to `true`.
  Stream<List<int>> get stderr;
}

/// Memory of a [WasmInstance].
///
/// Access via [WasmInstance.memory] or create via [WasmModule.createMemory].
///
/// Users of this type may not implement, mix-in or extend this type.
abstract class WasmMemory {
  /// The WASM spec defines the page size as 64KiB.
  static const int kPageSizeInBytes = 64 * 1024;

  /// The length of the memory in pages.
  int get lengthInPages;

  /// The length of the memory in bytes.
  int get lengthInBytes;

  /// The byte at the given [index].
  int operator [](
    int index,
  );

  /// Sets the byte at the given index to value.
  void operator []=(
    int index,
    int value,
  );

  /// A view into the memory.
  Uint8List get view;

  /// Grow the memory by [deltaPages] and invalidates any existing views into
  /// the memory.
  void grow(
    int deltaPages,
  );
}

/// A callable function from a [WasmInstance].
///
/// Access by calling [WasmInstance.lookupFunction].
///
/// Users of this type may not implement, mix-in or extend this type.
abstract class WasmFunction {
  /// Invokes the function with the given arguments.
  dynamic apply(
    List<dynamic> args,
  );
}

/// A global variable.
///
/// To access globals exported from an instance, call
/// [WasmInstance.lookupGlobal].
///
/// To import globals during module instantiation, use
/// [WasmInstanceBuilder.addGlobal].
///
/// Users of this type may not implement, mix-in or extend this type.
abstract class WasmGlobal {
  abstract dynamic value;
}

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
