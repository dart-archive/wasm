[![pub package](https://img.shields.io/pub/v/wasm.svg)](https://pub.dev/packages/wasm)
[![Build Status](https://github.com/dart-lang/wasm/workflows/CI/badge.svg)](https://github.com/dart-lang/wasm/actions?query=workflow%3ACI+branch%3Amain)
[![Coverage Status](https://coveralls.io/repos/github/dart-lang/wasm/badge.svg?branch=main)](https://coveralls.io/github/dart-lang/wasm?branch=main)

Provides utilities for loading and running WASM modules.

Built on top of the [Wasmer](https://github.com/wasmerio/wasmer) runtime.

Flutter and web are **not supported** at the moment. Stay tuned though ;)

## Setup

Start by installing the tools needed to build the Wasmer runtime:

   * Install the [Rust SDK].

   * On Windows, to get `link.exe`, install the [Visual Studio build tools]
     with the "Desktop development with C++"-option selected.

[Rust SDK]: https://www.rust-lang.org/tools/install
[Visual Studio build tools]: https://visualstudio.microsoft.com/visual-cpp-build-tools/

## Basic Usage

As a simple example, we'll try to call a simple C function from Dart using
`package:wasm`. For a more detailed example that uses WASI, check out the
example directory.

1. First create new Dart app folder: `dart create wasmtest`

1. Add a dependency to package `wasm` in `pubspec.yaml` and run `dart pub get`

1. Next run `dart run wasm:setup` to build the Wasmer runtime. This will take a few minutes.
   
1. Then add a new file `square.cc` with the following contents:

    ```c++
    extern "C" int square(int n) { return n * n; }
    ```

1. We can compile this C++ code to WASM using a recent version of the
[clang compiler](https://clang.llvm.org/get_started.html):

    ```bash
    clang --target=wasm32 -nostdlib "-Wl,--export-all" "-Wl,--no-entry" -o square.wasm square.cc
    ```

1. Replace the contents of your Dart program (`bin/wasmtest.dart`) with:

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

1. Run the Dart program: `dart run`. This should print:

    ```
    export memory: memory
    export function: int32 square(int32)
    
    144
    ```
