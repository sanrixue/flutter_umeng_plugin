#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = 'flutter_umeng_plugin'
  s.version          = '0.0.1'
  s.summary          = 'A new flutter plugin project.'
  s.description      = <<-DESC
A new flutter plugin project.
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.dependency 'UMCCommon','~> 2.1.1'
  s.dependency 'UMCCommonLog'
  s.dependency 'UMCAnalytics'
  s.dependency 'UMCErrorCatch'
  s.dependency 'UMCSecurityPlugins'
  s.dependency 'UMCPush'
  s.dependency 'UMCShare/UI'
  s.dependency 'UMCShare/Social/ReducedWeChat'
  s.dependency 'UMCShare/Social/ReducedQQ'
  s.dependency 'UMCShare/Social/ReducedSina' 
  s.static_framework = true
  s.ios.deployment_target = '8.0'
end

