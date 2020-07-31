

Pod::Spec.new do |s|
  s.name             = 'CocoaExpand'
  s.version          = '1.7.0'
  s.summary          = 'Cocoa SDK功能扩展（macApp）'
  s.description      = 'Cocoa SDK功能扩展（macApp）,提高开发效率'

  s.homepage         = 'https://github.com/shang1219178163/CocoaExpand'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'shang1219178163' => 'shang1219178163@gmail.com' }
  s.source           = { :git => 'https://github.com/shang1219178163/CocoaExpand.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.platform = :osx
  s.osx.deployment_target = "10.12"
  s.swift_version = "5.0"
  s.requires_arc = true
  
  s.source_files = 'CocoaExpand/Classes/**/*'
  s.resource_bundles = {
     'CocoaExpand' => ['CocoaExpand/Resources/*.xcassets']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'Cocoa'
  # s.dependency 'AFNetworking', '~> 2.3'
end
