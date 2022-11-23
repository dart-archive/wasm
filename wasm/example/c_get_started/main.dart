import 'dart:io';
import 'package:wasm/wasm.dart';

/// Start by installing the tools needed to build the Wasmer runtime:
///
/// * Install the [Rust SDK].
///
/// * On Windows, to get `link.exe`, install the [Visual Studio build tools]
/// with the "Desktop development with C++"-option selected.
///
/// [Rust SDK]: https://www.rust-lang.org/tools/install
/// [Visual Studio build tools]: https://visualstudio.microsoft.com/visual-cpp-build-tools/
///
/// As a simple example, we'll try to call a simple C function from Dart using
/// `package:wasm`.
///
/// * First create a new Dart project by running: `dart create wasmtest`.
///
/// * Add a dependency to package `wasm` in `pubspec.yaml`
///   and run `dart pub get`.
///
/// * Next run `dart run wasm:setup` to build the Wasmer runtime.
///   This will take a few minutes.
///
/// * Then add a new file `square.c`.
///
/// * Copy the content of build.dart into your project and run it.
///
/// * Copy the content of main.dart into your project and run it. This
///   should print:
///
/// ```
/// export memory: memory
/// export function: int32 square(int32)
///
/// 144
/// ```
///
/// ---
///
/// Quick Summary:
/// * square.c contains the logic on the C side.
/// * build.dart shows you how to build the C file to create a wasm module.
/// * main.dart shows you how to run the wasm module.
void main() {
  final data = File('square.wasm').readAsBytesSync();
  final mod = wasmModuleCompileSync(data);
  print(mod.describe());
  final inst = mod.builder().build();
  final square = inst.lookupFunction('square');
  print(square(12));
}
