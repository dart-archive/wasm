Provides utilities for loading and running WASM modules in Flutter apps.
Currently only Android is supported.

This is a wrapper around [package:wasm](https://github.com/dart-lang/wasm/blob/main/wasm/README.md).
See that package for more information and documentation. The basic
usage is mostly the same as in that package. The main thing this plugin does is
run `wasm:setup` for your target device during app compilation.

## Usage

1. Add a dependency to `flutter_wasm` in your `pubspec.yaml` and run
`flutter pub get`.

1. Next run `flutter pub run flutter_wasm:setup` to build the Wasmer runtime for
your host machine. This does not build the runtime for your target device. It
will take a few minutes.

1. Load your wasm code in your app. See the [example app](https://github.com/dart-lang/wasm/blob/main/flutter_wasm/example/lib/main.dart).

1. Run your app using `flutter run`. If you see an error at runtime saying
"libwasmer.so not found", just try rebuiling. The first build sometimes fails.
[#51](https://github.com/dart-lang/wasm/issues/51)
