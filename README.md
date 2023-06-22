These packages provide utilities for loading and running WASM modules.

## Status: Discontinued

**Notice**: This package was an experiment in consuming WASM code - integrating
a WASM runtime into applications, allowing them to leverage existing native
libraries compiled to WASM. While this is still an interesting path to explore,
generally as a team we're investing in producing WASM from Dart - letting a Dart
based app run in a WASM runtime (ala Flutter Web in a browser). See
https://docs.flutter.dev/platform-integration/web/wasm for more information.

For people who do wish to continue to experiment with a similar technique to
package:wasm / leveraging a wasm runtime, please feel free to fork this repo.

See also https://github.com/dart-lang/wasm/issues/146.

##  Packages

| Package | Description | Published Version |
| --- | --- | --- |
| [wasm](wasm/) | Runs WASM modules in Dart native. | [![pub package](https://img.shields.io/pub/v/wasm.svg)](https://pub.dev/packages/wasm) |
| [flutter_wasm](flutter_wasm/) | Runs WASM modules in Flutter. | |
