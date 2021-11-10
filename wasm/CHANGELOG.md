## 0.2.0-dev

- Update to Wasmer 2.0.0
- All WASM modules and isntances use a singleton store, to enable sharing of
  memory and functions.
- Add options to setup.dart for configuring the build.
- Add Module.serialize and Module.deserialize.
- Add bin/precompile.dart, which compiles and serializes wasm modules.

## 0.1.0+1

- Initial version
