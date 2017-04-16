Pod::Spec.new do |s|
  s.name             = 'CircularRevealKit'
  s.version          = '0.0.1'
  s.summary          = 'Circular reveal animations made easy'
  s.homepage         = 'https://github.com/T-Pro/CircularRevealKit'
  s.description      = 'This library was created to allow developers to implement the material design's reveal effect.'
  s.homepage         = 'https://github.com/T-Pro/CircularRevealKit'
  s.screenshots    = 'https://media.giphy.com/media/3cwSEnIK1GJEs/giphy.gif'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'ppamorim' => 'pp.amorim@hotmail.com' }
  s.source           = { :git => 'https://github.com/T-Pro/CircularRevealKit.git', :tag => s.version }
  s.ios.deployment_target = '8.0'
  s.source_files = 'CircularRevealKit/Classes/**/*'
  s.frameworks = 'UIKit'
end