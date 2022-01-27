#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint flutter_wasm.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'flutter_wasm'
  s.version          = '0.0.1'
  s.summary          = 'WASM in Flutter.'
  s.description      = <<-DESC
Provides utilities for loading and running WASM modules in Flutter apps.
                       DESC
  s.homepage         = 'https://github.com/dart-lang/wasm'
  s.license          = { :file => '../../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '8.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = {
    'DEFINES_MODULE' => 'YES',
    'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64',  # i386
    "OTHER_LDFLAGS[sdk=iphoneos*]" => "-force_load $(PODS_TARGET_SRCROOT)/Frameworks/flutter_wasm.xcframework/ios-arm64_armv7/libflutter_wasm.a",
    "OTHER_LDFLAGS[sdk=iphonesimulator*]" => "-force_load $(PODS_TARGET_SRCROOT)/Frameworks/flutter_wasm.xcframework/ios-x86_64-simulator/libflutter_wasm.a",
  }
  s.swift_version = '5.0'

  s.script_phases = [
    {
      :name => 'Build Wasm',
      :execution_position => :before_compile,
      :output_files => ['Frameworks/flutter_wasm.xcframework'],
      :script => 'flutter pub run flutter_wasm:ios_setup ${PODS_TARGET_SRCROOT}',  #  $(xcrun -sdk iphonesimulator --show-sdk-path | head -n 1)
    },
  ]

  s.ios.vendored_frameworks = 'Frameworks/flutter_wasm.xcframework'
end
