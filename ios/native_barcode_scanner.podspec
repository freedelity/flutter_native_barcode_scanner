#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint barcode_scanner.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'native_barcode_scanner'
  s.version          = '1.0.6'
  s.summary          = 'Barcode scanner plugin'
  s.description      = <<-DESC
Barcode scanner plugin
                       DESC
  s.homepage         = 'http://github.com/freedelity'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Freedelity' => 'mathieu@freedelity.be' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '11.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
