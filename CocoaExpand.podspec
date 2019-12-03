

Pod::Spec.new do |s|
  s.name             = 'CocoaExpand'
  s.version          = '0.1.1'
  s.summary          = 'A short description of CocoaExpand.'

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/shang1219178163@gmail.com/CocoaExpand'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'shang1219178163@gmail.com' => 'shang1219178163@gmail.com' }
  s.source           = { :git => 'https://github.com/shang1219178163/CocoaExpand.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.platform = :osx
  s.osx.deployment_target = "10.10"

  s.source_files = 'CocoaExpand/Classes/**/*'
  s.resource_bundles = {
    'CocoaExpand' => ['CocoaExpand/Assets/*.png']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'Cocoa'
  # s.dependency 'AFNetworking', '~> 2.3'
end
