// Copyright (c) 2020, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import '../wasm_api.dart';
import 'bindgen_api.dart';

extension BindingInstanceWasmInstanceExtension on WasmInstance {
  /// Invoke this to prepare the generated wasm function bindings.
  T takeExports<T>(
    T Function(BindingInstance) instance,
  ) {
    return instance(
      _BindingInstanceToWasmInstance(
        this,
      ),
    );
  }
}

extension BindingBuilderWasmInstanceBuilderExtension on WasmInstanceBuilder {
  /// Invoke this to prepare the generated wasm export bindings.
  void provideImports<I>(
    void Function(
      BindingBuilder builder,
      I imports,
    )
        fn,
    I imports,
  ) {
    fn(
      _BindingBuilderToWasmInstanceBuilder(
        this,
      ),
      imports,
    );
  }
}

class _BindingInstanceToWasmInstance implements BindingInstance {
  final WasmInstance instance;

  const _BindingInstanceToWasmInstance(
    this.instance,
  );

  @override
  void invokeFunction(
    String name,
    List<dynamic> arguments,
  ) {
    (instance.lookupFunction(name) as WasmFunction).apply(
      arguments,
    );
  }
}

class _BindingBuilderToWasmInstanceBuilder implements BindingBuilder {
  final WasmInstanceBuilder builder;

  const _BindingBuilderToWasmInstanceBuilder(
    this.builder,
  );

  @override
  void addImport(
    String module,
    String name,
    Function fn,
  ) {
    builder.addFunction(
      module,
      name,
      fn,
    );
  }
}
