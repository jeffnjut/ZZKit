Pod::Spec.new do |s|
    s.name         = 'ZZKit'
    s.version      = '1.0'
    s.summary      = '国产高性能轮子'
    s.homepage     = 'https://gitee.com/jeff_njut/ZZKit'
    s.license      = 'MIT'
    s.authors      = {'jeff_njut' => 'jeff_njut@163.com'}
    s.platform     = :ios, '8.0'
    s.source       = {:git => 'https://gitee.com/jeff_njut/ZZKit.git', :tag => s.version}
    
    s.subspec 'Base' do |ss|
        ss.requires_arc = false
        ss.source_files = ['ZZKit/**/*.{h,m,mm,c}','ZZKit-3rd/**/*.{h,m,mm,c}']
        ss.requires_arc = ['ZZKit/**/*.{h,m,mm,c}']
        ss.resources    = 'ZZKit/**/*.{png,jpg,jpeg,gif,xml,json,plist,xib,bundle}'
        ss.frameworks   = 'Foundation'
        ss.frameworks   = 'UIKit'
        ss.dependency     'Typeset'
        ss.dependency     'ReactiveObjC'
        ss.dependency     'Masonry'
        ss.dependency     'MBProgressHUD'
        ss.dependency     'lottie-ios'
        ss.dependency     'SDWebImage'
        ss.dependency     'YYModel'
        ss.dependency     'YYImage'
    end

    s.subspec 'Camera' do |ss|
        ss.requires_arc = true
        ss.source_files = 'ZZCamera/**/*.{h,m,mm,c}'
        ss.resources    = 'ZZCamera/**/*.{png,jpg,jpeg,gif,xml,json,plist,xib,bundle}'
        ss.frameworks   = 'Foundation'
    	ss.frameworks   = 'UIKit'
    	ss.frameworks   = 'SystemConfiguration'
    	ss.frameworks   = 'CoreImage'
    	ss.dependency     'SMPageControl'
    	ss.dependency     'ZZKit/Base'
    end
    
end
