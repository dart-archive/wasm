#import "FlutterWasmPlugin.h"
#if __has_include(<flutter_wasm/flutter_wasm-Swift.h>)
#import <flutter_wasm/flutter_wasm-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "flutter_wasm-Swift.h"
#endif

@implementation FlutterWasmPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlutterWasmPlugin registerWithRegistrar:registrar];
}
@end
