// Copyright (c) 2021, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

#include "dart_api.h"
#include "dart_api_dl.h"
#include <iostream>

#define FINALIZER(type)                                                        \
  void wasm_##type##_delete(void *native_object);                              \
  void wasm_##type##_finalizer(void *unused, void *native_object) {            \
    std::cerr << "ZZZZ wasm_" #type "_finalizer " << native_object << std::endl;\
    wasm_##type##_delete(native_object);                                       \
    std::cerr << "ZZZZ wasm_" #type "_finalizer DONE" << std::endl;\
  }                                                                            \
  DART_EXPORT void set_finalizer_for_##type(Dart_Handle dart_object,           \
                                            void *native_object) {             \
    Dart_NewFinalizableHandle_DL(dart_object, native_object, 0,                \
                                 wasm_##type##_finalizer);                     \
  }

FINALIZER(engine);
FINALIZER(store);
FINALIZER(module);
FINALIZER(instance);
FINALIZER(trap);
FINALIZER(memorytype);
FINALIZER(memory);
FINALIZER(func);
FINALIZER(global);
