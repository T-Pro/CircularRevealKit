#
# Be sure to run `pod lib lint CircularRevealKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'CircularRevealKit'
  s.version          = '0.0.1'
  s.summary          = 'Circular reveal animations made easy'

# This library was created to allow developers to implement the material design's reveal effect.

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/ppamorim/CircularRevealKit'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'ppamorim' => 'pepa.amorim@gmail.com' }
  s.source           = { :git => 'https://github.com/T-Pro/CircularRevealKit.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'

  s.source_files = 'CircularRevealKit/Classes/**/*'
  
  # s.resource_bundles = {
  #   'CircularRevealKit' => ['CircularRevealKit/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit'
end
