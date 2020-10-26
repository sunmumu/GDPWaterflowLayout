#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/

Pod::Spec.new do |s|
  s.name         = 'GDPWaterflowLayout'
  s.version      = '0.0.2'
  s.summary      = '宽相等瀑布流布局UICollectionViewLayout'
  s.homepage     = 'https://github.com/sunmumu/GDPWaterflowLayout'
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.authors      = { 'sunmumu' => '335089101@qq.com' }
  s.platform     = :ios, '9.0'
  s.ios.deployment_target = '9.0'
  s.source       = { :git => 'https://github.com/sunmumu/GDPWaterflowLayout.git', :tag => s.version.to_s }
  s.requires_arc = true
  s.source_files = 'GDPWaterflowLayout/**/*.{h,m}'
  s.public_header_files = 'GDPWaterflowLayout/**/*.{h}'
  
  s.libraries = 'z'
  s.frameworks = 'UIKit'
  

end
