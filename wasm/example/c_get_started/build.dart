import 'dart:io';

/// We can compile C code to WASM using a recent version of the
/// [clang compiler](https://clang.llvm.org/get_started.html):
void main() async {
  await Process.start(
    'clang',
    [
      // Set the build target to wasm.
      '--target=wasm32',
      // Do not use libc.
      '--no-standard-libraries',
      // Export all symbols from the compiled wasm file.
      '-Wl,--export-all',
      // -Wl,--no-entry Don't check for a main function.
      '-Wl,--no-entry',
      // Set the output destination.
      '-o',
      'square.wasm',
      // Set the input file.
      'square.c',
    ],
    mode: ProcessStartMode.inheritStdio,
  );
}
