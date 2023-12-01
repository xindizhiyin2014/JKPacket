#
# Be sure to run `pod lib lint JKPacket.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'JKPacket'
  s.version          = '0.2.0'
  s.summary          = 'a swift lifecycle reponsable observe tool'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  a tool can observe lifecycle data,and respoonse with RxSwift.
                       DESC

  s.homepage         = 'https://github.com/xindizhiyin2014/JKPacket'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'xindizhiyin2014' => '929097264@qq.com' }
  s.source           = { :git => 'https://github.com/xindizhiyin2014/JKPacket.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'
  s.osx.deployment_target = '10.11'
  s.swift_version = '4.2'

  s.subspec 'Core' do |ss|
      ss.source_files = 'JKPacket/Classes/Core/**/*'
  end
  
  s.subspec 'iOS' do |ss|
      ss.ios.deployment_target = '9.0'
      ss.source_files = 'JKPacket/Classes/iOS/**/*'
      ss.dependency 'JKPacket/Core'
  end
  
  s.subspec 'OSX' do |ss|
      ss.osx.deployment_target = '10.11'
      ss.source_files = 'JKPacket/Classes/OSX/**/*'
      ss.dependency 'JKPacket/Core'
  end
#  s.source_files = 'JKPacket/Classes/**/*'
  
  # s.resource_bundles = {
  #   'JKPacket' => ['JKPacket/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'RxSwift', '~> 5.0.0'
end
