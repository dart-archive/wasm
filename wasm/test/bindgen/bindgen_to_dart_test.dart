// Copyright (c) 2021, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:test/test.dart';
import 'package:wasm/src/bindgen/bindgen.dart';
import 'package:wasm/src/bindgen/bindgen_to_dart.dart';

void main() {
  void _expect(
    final String name,
    final WasmInfo info,
    final String output,
  ) {
    test(name, () {
      final result = bindgenToDart(
        info,
      ).content;
      try {
        expect(
          result,
          output,
        );
      } catch (e) {
        // To make it easier to copy and paste the fixture.
        print(result);
        rethrow;
      }
    });
  }

  group('bindgen_to_dart fixtures', () {
    group('imports', () {
      _expect(
        'zero',
        WasmInfo(imports: [], exports: [], moduleName: 'module'),
        _Fixtures.importsZero,
      );
      _expect(
        'one',
        WasmInfo(
          imports: [
            WasmFn(resultType: WasmType.unknown, params: [], name: 'fn'),
          ],
          exports: [],
          moduleName: 'module',
        ),
        _Fixtures.importsOne,
      );
      _expect(
        'many',
        WasmInfo(
          imports: [
            WasmFn(resultType: WasmType.unknown, params: [], name: 'fn1'),
            WasmFn(resultType: WasmType.unknown, params: [], name: 'fn2'),
          ],
          exports: [],
          moduleName: 'module',
        ),
        _Fixtures.importsMany,
      );
    });
    group('exports', () {
      _expect(
        'zero',
        WasmInfo(
          imports: [],
          exports: [],
          moduleName: 'module',
        ),
        _Fixtures.exportsZero,
      );
      _expect(
        'one',
        WasmInfo(
          imports: [],
          exports: [
            WasmFn(resultType: WasmType.unknown, params: [], name: 'fn1'),
          ],
          moduleName: 'module',
        ),
        _Fixtures.exportsOne,
      );
      _expect(
        'many',
        WasmInfo(
          imports: [],
          exports: [
            WasmFn(resultType: WasmType.unknown, params: [], name: 'fn1'),
            WasmFn(resultType: WasmType.unknown, params: [], name: 'fn2'),
          ],
          moduleName: 'module',
        ),
        _Fixtures.exportsMany,
      );
    });
    group('module name', () {
      _expect(
        'empty',
        WasmInfo(
          imports: [
            WasmFn(resultType: WasmType.unknown, params: [], name: 'fn1'),
          ],
          exports: [
            WasmFn(resultType: WasmType.unknown, params: [], name: 'fn2'),
          ],
          moduleName: '',
        ),
        _Fixtures.moduleNameEmpty,
      );
      _expect(
        'regular',
        WasmInfo(
          imports: [
            WasmFn(resultType: WasmType.unknown, params: [], name: 'fn1'),
          ],
          exports: [
            WasmFn(resultType: WasmType.unknown, params: [], name: 'fn2'),
          ],
          moduleName: 'module',
        ),
        _Fixtures.moduleNameRegular,
      );
    });
    group('fn', () {
      group('result type', () {
        _expect(
          WasmType.unit.toString(),
          WasmInfo(
            imports: [
              WasmFn(resultType: WasmType.unit, params: [], name: 'fn1'),
            ],
            exports: [
              WasmFn(resultType: WasmType.unit, params: [], name: 'fn2'),
            ],
            moduleName: 'module',
          ),
          _Fixtures.fnResultTypeUnit,
        );
        _expect(
          WasmType.int32.toString(),
          WasmInfo(
            imports: [
              WasmFn(resultType: WasmType.int32, params: [], name: 'fn1'),
            ],
            exports: [
              WasmFn(resultType: WasmType.int32, params: [], name: 'fn2'),
            ],
            moduleName: 'module',
          ),
          _Fixtures.fnResultTypeInt32,
        );
        _expect(
          WasmType.unknown.toString(),
          WasmInfo(
            imports: [
              WasmFn(resultType: WasmType.unknown, params: [], name: 'fn1'),
            ],
            exports: [
              WasmFn(resultType: WasmType.unknown, params: [], name: 'fn2'),
            ],
            moduleName: 'module',
          ),
          _Fixtures.fnResultTypeUnknown,
        );
      });
      group('name', () {
        _expect(
          'empty',
          WasmInfo(
            imports: [
              WasmFn(resultType: WasmType.unknown, params: [], name: ''),
            ],
            exports: [
              WasmFn(resultType: WasmType.unknown, params: [], name: ''),
            ],
            moduleName: 'module',
          ),
          _Fixtures.fnNameEmpty,
        );
        _expect(
          'regular',
          WasmInfo(
            imports: [
              WasmFn(resultType: WasmType.unknown, params: [], name: 'fn1'),
            ],
            exports: [
              WasmFn(resultType: WasmType.unknown, params: [], name: 'fn2'),
            ],
            moduleName: 'module',
          ),
          _Fixtures.fnNameRegular,
        );
      });
      group('params', () {
        _expect(
          'zero',
          WasmInfo(
            imports: [
              WasmFn(resultType: WasmType.unknown, params: [], name: 'fn1'),
            ],
            exports: [
              WasmFn(resultType: WasmType.unknown, params: [], name: 'fn2'),
            ],
            moduleName: 'module',
          ),
          _Fixtures.fnParamsZero,
        );
        _expect(
          'one',
          WasmInfo(
            imports: [
              WasmFn(
                resultType: WasmType.unknown,
                params: [WasmType.unit],
                name: 'fn1',
              ),
            ],
            exports: [
              WasmFn(
                resultType: WasmType.unknown,
                params: [WasmType.unit],
                name: 'fn2',
              ),
            ],
            moduleName: 'module',
          ),
          _Fixtures.fnParamsOne,
        );
        _expect(
          'many',
          WasmInfo(
            imports: [
              WasmFn(
                resultType: WasmType.unknown,
                params: [WasmType.unit, WasmType.unknown],
                name: 'fn1',
              ),
            ],
            exports: [
              WasmFn(
                resultType: WasmType.unknown,
                params: [WasmType.unit, WasmType.unknown],
                name: 'fn2',
              ),
            ],
            moduleName: 'module',
          ),
          _Fixtures.fnParamsMany,
        );
        group('type', () {
          _expect(
            WasmType.unit.toString(),
            WasmInfo(
              imports: [
                WasmFn(
                  resultType: WasmType.unknown,
                  params: [WasmType.unit],
                  name: '',
                ),
              ],
              exports: [
                WasmFn(
                  resultType: WasmType.unknown,
                  params: [WasmType.unit],
                  name: '',
                ),
              ],
              moduleName: 'module',
            ),
            _Fixtures.fnParamsTypeUnit,
          );
          _expect(
            WasmType.int32.toString(),
            WasmInfo(
              imports: [
                WasmFn(
                  resultType: WasmType.unknown,
                  params: [WasmType.int32],
                  name: '',
                ),
              ],
              exports: [
                WasmFn(
                  resultType: WasmType.unknown,
                  params: [WasmType.int32],
                  name: '',
                ),
              ],
              moduleName: 'module',
            ),
            _Fixtures.fnParamsTypeInt32,
          );
          _expect(
            WasmType.unknown.toString(),
            WasmInfo(
              imports: [
                WasmFn(
                  resultType: WasmType.unknown,
                  params: [WasmType.unknown],
                  name: '',
                ),
              ],
              exports: [
                WasmFn(
                  resultType: WasmType.unknown,
                  params: [WasmType.unknown],
                  name: '',
                ),
              ],
              moduleName: 'module',
            ),
            _Fixtures.fnParamsTypeUnknown,
          );
        });
      });
    });
  });
}

abstract class _Fixtures {
  static const String importsZero = r'''
// ignore_for_file: type=lint
// This was generated by wasm-bindgen.
import 'package:wasm/wasm_bindgen_api.dart';

void fillWasmModuleImports_module(
  BindingBuilder builder,
  WasmImportDelegate_module imports,
) {
}

WasmExportDelegate_module takeWasmModuleExports_module(
  BindingInstance instance,
) {
  return _WasmExportDelegate_moduleImpl(instance);
}

/// Expected wasm imports.
abstract class WasmImportDelegate_module {
}

/// Available wasm exports.
abstract class WasmExportDelegate_module {
}

// Everything below is internal.

class _WasmExportDelegate_moduleImpl implements WasmExportDelegate_module {
  final BindingInstance _instance;

  const _WasmExportDelegate_moduleImpl(
    this._instance,
  );
}''';
  static const String importsOne = r'''
// ignore_for_file: type=lint
// This was generated by wasm-bindgen.
import 'package:wasm/wasm_bindgen_api.dart';

void fillWasmModuleImports_module(
  BindingBuilder builder,
  WasmImportDelegate_module imports,
) {
  builder.addImport('module', 'fn', imports.$fn);
}

WasmExportDelegate_module takeWasmModuleExports_module(
  BindingInstance instance,
) {
  return _WasmExportDelegate_moduleImpl(instance);
}

/// Expected wasm imports.
abstract class WasmImportDelegate_module {
  dynamic $fn();
}

/// Available wasm exports.
abstract class WasmExportDelegate_module {
}

// Everything below is internal.

class _WasmExportDelegate_moduleImpl implements WasmExportDelegate_module {
  final BindingInstance _instance;

  const _WasmExportDelegate_moduleImpl(
    this._instance,
  );
}''';
  static const String importsMany = r'''
// ignore_for_file: type=lint
// This was generated by wasm-bindgen.
import 'package:wasm/wasm_bindgen_api.dart';

void fillWasmModuleImports_module(
  BindingBuilder builder,
  WasmImportDelegate_module imports,
) {
  builder.addImport('module', 'fn1', imports.$fn1);
  builder.addImport('module', 'fn2', imports.$fn2);
}

WasmExportDelegate_module takeWasmModuleExports_module(
  BindingInstance instance,
) {
  return _WasmExportDelegate_moduleImpl(instance);
}

/// Expected wasm imports.
abstract class WasmImportDelegate_module {
  dynamic $fn1();

  dynamic $fn2();
}

/// Available wasm exports.
abstract class WasmExportDelegate_module {
}

// Everything below is internal.

class _WasmExportDelegate_moduleImpl implements WasmExportDelegate_module {
  final BindingInstance _instance;

  const _WasmExportDelegate_moduleImpl(
    this._instance,
  );
}''';
  static const String exportsZero = r'''
// ignore_for_file: type=lint
// This was generated by wasm-bindgen.
import 'package:wasm/wasm_bindgen_api.dart';

void fillWasmModuleImports_module(
  BindingBuilder builder,
  WasmImportDelegate_module imports,
) {
}

WasmExportDelegate_module takeWasmModuleExports_module(
  BindingInstance instance,
) {
  return _WasmExportDelegate_moduleImpl(instance);
}

/// Expected wasm imports.
abstract class WasmImportDelegate_module {
}

/// Available wasm exports.
abstract class WasmExportDelegate_module {
}

// Everything below is internal.

class _WasmExportDelegate_moduleImpl implements WasmExportDelegate_module {
  final BindingInstance _instance;

  const _WasmExportDelegate_moduleImpl(
    this._instance,
  );
}''';
  static const String exportsOne = r'''
// ignore_for_file: type=lint
// This was generated by wasm-bindgen.
import 'package:wasm/wasm_bindgen_api.dart';

void fillWasmModuleImports_module(
  BindingBuilder builder,
  WasmImportDelegate_module imports,
) {
}

WasmExportDelegate_module takeWasmModuleExports_module(
  BindingInstance instance,
) {
  return _WasmExportDelegate_moduleImpl(instance);
}

/// Expected wasm imports.
abstract class WasmImportDelegate_module {
}

/// Available wasm exports.
abstract class WasmExportDelegate_module {
  dynamic $fn1();
}

// Everything below is internal.

class _WasmExportDelegate_moduleImpl implements WasmExportDelegate_module {
  final BindingInstance _instance;

  const _WasmExportDelegate_moduleImpl(
    this._instance,
  );

  @override
  dynamic $fn1() {
    return this._instance.invokeFunction(
      'fn1',
      [],
    );
  }
}''';
  static const String exportsMany = r'''
// ignore_for_file: type=lint
// This was generated by wasm-bindgen.
import 'package:wasm/wasm_bindgen_api.dart';

void fillWasmModuleImports_module(
  BindingBuilder builder,
  WasmImportDelegate_module imports,
) {
}

WasmExportDelegate_module takeWasmModuleExports_module(
  BindingInstance instance,
) {
  return _WasmExportDelegate_moduleImpl(instance);
}

/// Expected wasm imports.
abstract class WasmImportDelegate_module {
}

/// Available wasm exports.
abstract class WasmExportDelegate_module {
  dynamic $fn1();

  dynamic $fn2();
}

// Everything below is internal.

class _WasmExportDelegate_moduleImpl implements WasmExportDelegate_module {
  final BindingInstance _instance;

  const _WasmExportDelegate_moduleImpl(
    this._instance,
  );

  @override
  dynamic $fn1() {
    return this._instance.invokeFunction(
      'fn1',
      [],
    );
  }

  @override
  dynamic $fn2() {
    return this._instance.invokeFunction(
      'fn2',
      [],
    );
  }
}''';
  static const String moduleNameEmpty = r'''
// ignore_for_file: type=lint
// This was generated by wasm-bindgen.
import 'package:wasm/wasm_bindgen_api.dart';

void fillWasmModuleImports_(
  BindingBuilder builder,
  WasmImportDelegate_ imports,
) {
  builder.addImport('', 'fn1', imports.$fn1);
}

WasmExportDelegate_ takeWasmModuleExports_(
  BindingInstance instance,
) {
  return _WasmExportDelegate_Impl(instance);
}

/// Expected wasm imports.
abstract class WasmImportDelegate_ {
  dynamic $fn1();
}

/// Available wasm exports.
abstract class WasmExportDelegate_ {
  dynamic $fn2();
}

// Everything below is internal.

class _WasmExportDelegate_Impl implements WasmExportDelegate_ {
  final BindingInstance _instance;

  const _WasmExportDelegate_Impl(
    this._instance,
  );

  @override
  dynamic $fn2() {
    return this._instance.invokeFunction(
      'fn2',
      [],
    );
  }
}''';
  static const String moduleNameRegular = r'''
// ignore_for_file: type=lint
// This was generated by wasm-bindgen.
import 'package:wasm/wasm_bindgen_api.dart';

void fillWasmModuleImports_module(
  BindingBuilder builder,
  WasmImportDelegate_module imports,
) {
  builder.addImport('module', 'fn1', imports.$fn1);
}

WasmExportDelegate_module takeWasmModuleExports_module(
  BindingInstance instance,
) {
  return _WasmExportDelegate_moduleImpl(instance);
}

/// Expected wasm imports.
abstract class WasmImportDelegate_module {
  dynamic $fn1();
}

/// Available wasm exports.
abstract class WasmExportDelegate_module {
  dynamic $fn2();
}

// Everything below is internal.

class _WasmExportDelegate_moduleImpl implements WasmExportDelegate_module {
  final BindingInstance _instance;

  const _WasmExportDelegate_moduleImpl(
    this._instance,
  );

  @override
  dynamic $fn2() {
    return this._instance.invokeFunction(
      'fn2',
      [],
    );
  }
}''';
  static const String fnResultTypeUnit = r'''
// ignore_for_file: type=lint
// This was generated by wasm-bindgen.
import 'package:wasm/wasm_bindgen_api.dart';

void fillWasmModuleImports_module(
  BindingBuilder builder,
  WasmImportDelegate_module imports,
) {
  builder.addImport('module', 'fn1', imports.$fn1);
}

WasmExportDelegate_module takeWasmModuleExports_module(
  BindingInstance instance,
) {
  return _WasmExportDelegate_moduleImpl(instance);
}

/// Expected wasm imports.
abstract class WasmImportDelegate_module {
  void $fn1();
}

/// Available wasm exports.
abstract class WasmExportDelegate_module {
  void $fn2();
}

// Everything below is internal.

class _WasmExportDelegate_moduleImpl implements WasmExportDelegate_module {
  final BindingInstance _instance;

  const _WasmExportDelegate_moduleImpl(
    this._instance,
  );

  @override
  void $fn2() {
    return this._instance.invokeFunction(
      'fn2',
      [],
    );
  }
}''';
  static const String fnResultTypeInt32 = r'''
// ignore_for_file: type=lint
// This was generated by wasm-bindgen.
import 'package:wasm/wasm_bindgen_api.dart';

void fillWasmModuleImports_module(
  BindingBuilder builder,
  WasmImportDelegate_module imports,
) {
  builder.addImport('module', 'fn1', imports.$fn1);
}

WasmExportDelegate_module takeWasmModuleExports_module(
  BindingInstance instance,
) {
  return _WasmExportDelegate_moduleImpl(instance);
}

/// Expected wasm imports.
abstract class WasmImportDelegate_module {
  int $fn1();
}

/// Available wasm exports.
abstract class WasmExportDelegate_module {
  int $fn2();
}

// Everything below is internal.

class _WasmExportDelegate_moduleImpl implements WasmExportDelegate_module {
  final BindingInstance _instance;

  const _WasmExportDelegate_moduleImpl(
    this._instance,
  );

  @override
  int $fn2() {
    return this._instance.invokeFunction(
      'fn2',
      [],
    );
  }
}''';
  static const String fnResultTypeUnknown = r'''
// ignore_for_file: type=lint
// This was generated by wasm-bindgen.
import 'package:wasm/wasm_bindgen_api.dart';

void fillWasmModuleImports_module(
  BindingBuilder builder,
  WasmImportDelegate_module imports,
) {
  builder.addImport('module', 'fn1', imports.$fn1);
}

WasmExportDelegate_module takeWasmModuleExports_module(
  BindingInstance instance,
) {
  return _WasmExportDelegate_moduleImpl(instance);
}

/// Expected wasm imports.
abstract class WasmImportDelegate_module {
  dynamic $fn1();
}

/// Available wasm exports.
abstract class WasmExportDelegate_module {
  dynamic $fn2();
}

// Everything below is internal.

class _WasmExportDelegate_moduleImpl implements WasmExportDelegate_module {
  final BindingInstance _instance;

  const _WasmExportDelegate_moduleImpl(
    this._instance,
  );

  @override
  dynamic $fn2() {
    return this._instance.invokeFunction(
      'fn2',
      [],
    );
  }
}''';
  static const String fnNameEmpty = r'''
// ignore_for_file: type=lint
// This was generated by wasm-bindgen.
import 'package:wasm/wasm_bindgen_api.dart';

void fillWasmModuleImports_module(
  BindingBuilder builder,
  WasmImportDelegate_module imports,
) {
  builder.addImport('module', '', imports.$);
}

WasmExportDelegate_module takeWasmModuleExports_module(
  BindingInstance instance,
) {
  return _WasmExportDelegate_moduleImpl(instance);
}

/// Expected wasm imports.
abstract class WasmImportDelegate_module {
  dynamic $();
}

/// Available wasm exports.
abstract class WasmExportDelegate_module {
  dynamic $();
}

// Everything below is internal.

class _WasmExportDelegate_moduleImpl implements WasmExportDelegate_module {
  final BindingInstance _instance;

  const _WasmExportDelegate_moduleImpl(
    this._instance,
  );

  @override
  dynamic $() {
    return this._instance.invokeFunction(
      '',
      [],
    );
  }
}''';
  static const String fnNameRegular = r'''
// ignore_for_file: type=lint
// This was generated by wasm-bindgen.
import 'package:wasm/wasm_bindgen_api.dart';

void fillWasmModuleImports_module(
  BindingBuilder builder,
  WasmImportDelegate_module imports,
) {
  builder.addImport('module', 'fn1', imports.$fn1);
}

WasmExportDelegate_module takeWasmModuleExports_module(
  BindingInstance instance,
) {
  return _WasmExportDelegate_moduleImpl(instance);
}

/// Expected wasm imports.
abstract class WasmImportDelegate_module {
  dynamic $fn1();
}

/// Available wasm exports.
abstract class WasmExportDelegate_module {
  dynamic $fn2();
}

// Everything below is internal.

class _WasmExportDelegate_moduleImpl implements WasmExportDelegate_module {
  final BindingInstance _instance;

  const _WasmExportDelegate_moduleImpl(
    this._instance,
  );

  @override
  dynamic $fn2() {
    return this._instance.invokeFunction(
      'fn2',
      [],
    );
  }
}''';
  static const String fnParamsZero = r'''
// ignore_for_file: type=lint
// This was generated by wasm-bindgen.
import 'package:wasm/wasm_bindgen_api.dart';

void fillWasmModuleImports_module(
  BindingBuilder builder,
  WasmImportDelegate_module imports,
) {
  builder.addImport('module', 'fn1', imports.$fn1);
}

WasmExportDelegate_module takeWasmModuleExports_module(
  BindingInstance instance,
) {
  return _WasmExportDelegate_moduleImpl(instance);
}

/// Expected wasm imports.
abstract class WasmImportDelegate_module {
  dynamic $fn1();
}

/// Available wasm exports.
abstract class WasmExportDelegate_module {
  dynamic $fn2();
}

// Everything below is internal.

class _WasmExportDelegate_moduleImpl implements WasmExportDelegate_module {
  final BindingInstance _instance;

  const _WasmExportDelegate_moduleImpl(
    this._instance,
  );

  @override
  dynamic $fn2() {
    return this._instance.invokeFunction(
      'fn2',
      [],
    );
  }
}''';
  static const String fnParamsOne = r'''
// ignore_for_file: type=lint
// This was generated by wasm-bindgen.
import 'package:wasm/wasm_bindgen_api.dart';

void fillWasmModuleImports_module(
  BindingBuilder builder,
  WasmImportDelegate_module imports,
) {
  builder.addImport('module', 'fn1', imports.$fn1);
}

WasmExportDelegate_module takeWasmModuleExports_module(
  BindingInstance instance,
) {
  return _WasmExportDelegate_moduleImpl(instance);
}

/// Expected wasm imports.
abstract class WasmImportDelegate_module {
  dynamic $fn1(
    void $p0,
  );
}

/// Available wasm exports.
abstract class WasmExportDelegate_module {
  dynamic $fn2(
    void $p0,
  );
}

// Everything below is internal.

class _WasmExportDelegate_moduleImpl implements WasmExportDelegate_module {
  final BindingInstance _instance;

  const _WasmExportDelegate_moduleImpl(
    this._instance,
  );

  @override
  dynamic $fn2(
    void $p0,
  ) {
    return this._instance.invokeFunction(
      'fn2',
      [
        p0,
      ],
    );
  }
}''';
  static const String fnParamsMany = r'''
// ignore_for_file: type=lint
// This was generated by wasm-bindgen.
import 'package:wasm/wasm_bindgen_api.dart';

void fillWasmModuleImports_module(
  BindingBuilder builder,
  WasmImportDelegate_module imports,
) {
  builder.addImport('module', 'fn1', imports.$fn1);
}

WasmExportDelegate_module takeWasmModuleExports_module(
  BindingInstance instance,
) {
  return _WasmExportDelegate_moduleImpl(instance);
}

/// Expected wasm imports.
abstract class WasmImportDelegate_module {
  dynamic $fn1(
    void $p0,
    dynamic $p1,
  );
}

/// Available wasm exports.
abstract class WasmExportDelegate_module {
  dynamic $fn2(
    void $p0,
    dynamic $p1,
  );
}

// Everything below is internal.

class _WasmExportDelegate_moduleImpl implements WasmExportDelegate_module {
  final BindingInstance _instance;

  const _WasmExportDelegate_moduleImpl(
    this._instance,
  );

  @override
  dynamic $fn2(
    void $p0,
    dynamic $p1,
  ) {
    return this._instance.invokeFunction(
      'fn2',
      [
        p0,
        p1,
      ],
    );
  }
}''';
  static const String fnParamsTypeUnit = r'''
// ignore_for_file: type=lint
// This was generated by wasm-bindgen.
import 'package:wasm/wasm_bindgen_api.dart';

void fillWasmModuleImports_module(
  BindingBuilder builder,
  WasmImportDelegate_module imports,
) {
  builder.addImport('module', '', imports.$);
}

WasmExportDelegate_module takeWasmModuleExports_module(
  BindingInstance instance,
) {
  return _WasmExportDelegate_moduleImpl(instance);
}

/// Expected wasm imports.
abstract class WasmImportDelegate_module {
  dynamic $(
    void $p0,
  );
}

/// Available wasm exports.
abstract class WasmExportDelegate_module {
  dynamic $(
    void $p0,
  );
}

// Everything below is internal.

class _WasmExportDelegate_moduleImpl implements WasmExportDelegate_module {
  final BindingInstance _instance;

  const _WasmExportDelegate_moduleImpl(
    this._instance,
  );

  @override
  dynamic $(
    void $p0,
  ) {
    return this._instance.invokeFunction(
      '',
      [
        p0,
      ],
    );
  }
}''';
  static const String fnParamsTypeInt32 = r'''
// ignore_for_file: type=lint
// This was generated by wasm-bindgen.
import 'package:wasm/wasm_bindgen_api.dart';

void fillWasmModuleImports_module(
  BindingBuilder builder,
  WasmImportDelegate_module imports,
) {
  builder.addImport('module', '', imports.$);
}

WasmExportDelegate_module takeWasmModuleExports_module(
  BindingInstance instance,
) {
  return _WasmExportDelegate_moduleImpl(instance);
}

/// Expected wasm imports.
abstract class WasmImportDelegate_module {
  dynamic $(
    int $p0,
  );
}

/// Available wasm exports.
abstract class WasmExportDelegate_module {
  dynamic $(
    int $p0,
  );
}

// Everything below is internal.

class _WasmExportDelegate_moduleImpl implements WasmExportDelegate_module {
  final BindingInstance _instance;

  const _WasmExportDelegate_moduleImpl(
    this._instance,
  );

  @override
  dynamic $(
    int $p0,
  ) {
    return this._instance.invokeFunction(
      '',
      [
        p0,
      ],
    );
  }
}''';
  static const String fnParamsTypeUnknown = r'''
// ignore_for_file: type=lint
// This was generated by wasm-bindgen.
import 'package:wasm/wasm_bindgen_api.dart';

void fillWasmModuleImports_module(
  BindingBuilder builder,
  WasmImportDelegate_module imports,
) {
  builder.addImport('module', '', imports.$);
}

WasmExportDelegate_module takeWasmModuleExports_module(
  BindingInstance instance,
) {
  return _WasmExportDelegate_moduleImpl(instance);
}

/// Expected wasm imports.
abstract class WasmImportDelegate_module {
  dynamic $(
    dynamic $p0,
  );
}

/// Available wasm exports.
abstract class WasmExportDelegate_module {
  dynamic $(
    dynamic $p0,
  );
}

// Everything below is internal.

class _WasmExportDelegate_moduleImpl implements WasmExportDelegate_module {
  final BindingInstance _instance;

  const _WasmExportDelegate_moduleImpl(
    this._instance,
  );

  @override
  dynamic $(
    dynamic $p0,
  ) {
    return this._instance.invokeFunction(
      '',
      [
        p0,
      ],
    );
  }
}''';
}
