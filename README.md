Provides utilities for loading and running WASM modules

Built on top of the [Wasmer](https://github.com/wasmerio/wasmer) runtime.

## Setup

Run `dart run wasm:setup` to build the Wasmer runtime.

## Basic Usage

As a simple example, we'll try to call a simple C function from Dart using
`package:wasm`. For a more detailed example that uses WASI, check out the
example directory.

1. First create new Dart app folder: `dart create wasmtest`

1. Then add a new file `square.cc` with the following contents:

    ```c++
    extern "C" int square(int n) { return n * n; }
    ```

1. We can compile this C++ code to WASM using a recent version of the
[clang compiler](https://clang.llvm.org/get_started.html):

    ```bash
    clang --target=wasm32 -nostdlib -Wl,--export-all -Wl,--no-entry -o square.wasm square.cc
    ```

Then we can load and run it like this:

1. Add a dependency to package `wasm` in `pubspec.yaml` and run `dart pub get`

1. Replace the contents of `bin/wasmtest.dart` with:

    ```dart
    import 'dart:io';
    import 'package:wasm/wasm.dart';
    
    void main() {
      final data = File('square.wasm').readAsBytesSync();
      final mod = WasmModule(data);
      print(mod.describe());
      final inst = mod.builder().build();
      final square = inst.lookupFunction('square');
      print(square(12));
    }
    ```

1. Copy wasmer runtime built during setup
(`/wasm/.dart_tool/wasm/libwasmer.dylib`; `/wasmer.dll` on Windows)
to the `.dart_tool/wasm` subfolder of your `wasmtest` app folder.

1. Run the Dart program: `dart run`

This should print:

```
export memory: memory
export function: int32 square(int32)

144
```
