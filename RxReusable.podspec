Pod::Spec.new do |s|
  s.name             = 'RxReusable'
  s.version          = '0.3.1'
  s.summary          = 'Reusable cells and views for RxSwift'
  s.homepage         = 'https://github.com/devxoul/RxReusable'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Suyeol Jeon' => 'devxoul@gmail.com' }
  s.source           = { :git => 'https://github.com/devxoul/RxReusable.git',
                         :tag => s.version.to_s }
  s.source_files     = 'RxReusable/Sources/*.swift'
  s.frameworks       = 'UIKit', 'Foundation'
  s.requires_arc     = true

  s.dependency 'RxSwift', '>= 3.0'
  s.dependency 'RxCocoa', '>= 3.0'

  s.ios.deployment_target = '8.0'

  s.pod_target_xcconfig = {
    'SWIFT_VERSION' => '3.0'
  }
end
