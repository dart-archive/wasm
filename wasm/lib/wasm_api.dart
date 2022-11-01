// Copyright (c) 2020, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// Warning: For the time being, as long as this package is experimental, the
/// public API is experimental and may change without notice. This will change
/// once the design and implementation have been finalized and this package
/// is no longer experimental.
library _;

import 'dart:typed_data';

// TODO(modulovalue): document that the public api of this type is sealed.
/// A compiled module that can be instantiated.
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

  // TODO(modulovalue): remove this or design more 
  // TODO(modulovalue):  complete debugging facilities.
  /// Returns a description of all of the module's imports and exports, for
  /// debugging.
  String describe();
}

// TODO(modulovalue): document that the public api of this type is sealed.
/// Used to collect all of the imports that a [WasmModule] requires before it is
/// built.
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
  /// TODO(modulovalue): make val a more refined type.
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

// TODO(modulovalue): document that the public api of this type is sealed.
/// An instantiated [WasmModule].
///
/// Created by calling [WasmInstanceBuilder.build].
abstract class WasmInstance {
  /// Searches the instantiated module for the given function.
  ///
  /// Returns a [WasmFunction], but the return type is [dynamic] to allow
  /// easy invocation as a [Function].
  ///
  /// Returns `null` if no function exists with name [name].
  /// TODO(modulovalue): return a more refined type.
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
  /// TODO(modulovalue): what happens when captureStdout is set to false?
  /// TODO(modulovalue): replace with a capability fore more safety?
  Stream<List<int>> get stdout;

  /// Returns a stream that reads from `stderr`.
  ///
  /// To use this, you must enable WASI when instantiating the module, and set
  /// `captureStderr` to `true`.
  /// TODO(modulovalue): what happens when captureStderr is set to false?
  /// TODO(modulovalue): replace with a capability fore more safety?
  Stream<List<int>> get stderr;
}

// TODO(modulovalue): document that the public api of this type is sealed.
/// Memory of a [WasmInstance].
///
/// Access via [WasmInstance.memory] or create via [WasmModule.createMemory].
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

  // TODO(modulovalue): consider hiding uint8list and exposing the list
  // TODO(modulovalue):  interface. this depends on the use cases that
  // TODO(modulovalue):  we want to support.
  /// A view into the memory.
  Uint8List get view;

  /// Grow the memory by [deltaPages] and invalidates any existing views into
  /// the memory.
  void grow(
    int deltaPages,
  );
}

// TODO(modulovalue): document that the public api of this type is sealed.
/// A callable function from a [WasmInstance].
///
/// Access by calling [WasmInstance.lookupFunction].
abstract class WasmFunction {
  dynamic apply(
    List<dynamic> args,
  );

  // TODO(modulovalue): don't expose toString, but some debug method.
  @override
  String toString();
}

// TODO(modulovalue): document that the public api of this type is sealed.
/// A global variable.
///
/// To access globals exported from an instance, call
/// [WasmInstance.lookupGlobal].
///
/// To import globals during module instantiation, use
/// [WasmInstanceBuilder.addGlobal].
abstract class WasmGlobal {
  abstract dynamic value;

  // TODO(modulovalue): don't expose toString, but some debug method.
  @override
  String toString();
}

/// Error specific to unexpected behavior or incorrect usage of this package.
/// TODO(modulovalue): have specific error subtypes for each use case.
abstract class WasmError implements Error {
  /// Describes the nature of the error.
  String get message;

  @override
  String toString();
}

/// Exception that wraps exceptions (traps) thrown inside wasm code.
/// TODO(modulovalue): have specific exception subtypes for each use case.
abstract class WasmException implements Exception {
  /// Describes the nature of the exception.
  String get message;
}
