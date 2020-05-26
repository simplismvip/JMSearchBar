#
# Be sure to run `pod lib lint JMSearchBar.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'JMSearchBar'
  s.version          = '0.0.2'
  s.summary          = '一个使用Swift写的搜索组件。'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
🔍 Awesome fully customize search view like Pinterest written in Swift 5.0 hhh!
                       DESC

  s.homepage         = 'https://github.com/simplismvip/JMSearchBar'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { '明' => 'tonyzhao60@gmail.com' }
  s.source           = { :git => 'https://github.com/simplismvip/JMSearchBar.git', :tag => s.version.to_s }
  s.social_media_url = 'http://www.restcy.com'

  s.ios.deployment_target = '10.0'

  # s.source_files = 'Source/*.{h,swift}'
  # s.resource_bundles = { 'JMSearchBar' => ['JMSearchBar/Assets/*.png'] }

  s.swift_version = '4.0'
  s.platform      = :ios, '10.0'
  s.requires_arc  = true

  s.source_files = [ 'Source/*.{h,swift}' ]
  s.resources = [ 'Source/*.bundle' ]

  s.frameworks = 'UIKit'

  s.dependency 'SnapKit'
  s.dependency 'RxCocoa'
  s.dependency 'RxSwift'
  s.dependency 'ZJMKit'
end
