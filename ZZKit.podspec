Pod::Spec.new do |s|
  s.name         = 'ZZKit'
  s.summary      = 'A collection of iOS components.'
  s.version      = '1.0'
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.authors      = { 'jeff' => 'jeff_njut@163.com' }
  s.social_media_url = 'jeff_njut@163.com'
  s.homepage     = 'https://gitee.com/jeff_njut/ZZKit'
  s.platform     = :ios, '9.0'
  s.ios.deployment_target = '9.0'
  s.source       = { :git => 'https://gitee.com/jeff_njut/ZZKit.git', :tag => s.version.to_s }
  
  s.requires_arc = true
  s.source_files = ['ZZKit/**/*.{h,m}', 'ZZCamera/**/*.{h,m}']
  s.public_header_files = ['ZZKit/**/*.{h}', 'ZZCamera/**/*.{h}']
  s.resources    = 'ZZKit/**/*.{png,jpg,jpeg,gif,xml,json,plist,xib,bundle}','ZZCamera/**/*.{png,jpg,jpeg,gif,xml,json,plist,xib,bundle}'

  non_arc_files = 'ZZKit-3rd/**/*.{h,m,mm,c}'
  s.ios.exclude_files = non_arc_files
  s.subspec 'no-arc' do |sna|
    sna.requires_arc = false
    sna.source_files = non_arc_files
  end

  # s.libraries = 'z', 'sqlite3'
  s.frameworks = 'Foundation', 'UIKit', 'SystemConfiguration', 'CoreImage'
  s.dependency 'Typeset'
  s.dependency 'ReactiveObjC'
  s.dependency 'Masonry'
  s.dependency 'MBProgressHUD'
  s.dependency 'lottie-ios'
  s.dependency 'SDWebImage'
  s.dependency 'YYModel'
  s.dependency 'YYImage'
  s.dependency 'SMPageControl'
end