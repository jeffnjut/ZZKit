Pod::Spec.new do |s|
    s.name         = 'ZZKit'
    s.version      = '1.0'
    s.summary      = '国产高性能轮子'
    s.homepage     = 'https://gitee.com/jeff_njut/ZZKit'
    s.license      = 'MIT'
    s.authors      = {'jeff_njut' => 'jeff_njut@163.com'}
    s.platform     = :ios, '8.0'
    s.source       = {:git => 'https://gitee.com/jeff_njut/ZZKit.git', :tag => s.version}
    s.requires_arc = true
    
    s.subspec 'ZZKit' do |ss|
        ss.source_files = 'ZZKit/**/*.{h,m,mm,c}'
        ss.resources    = 'ZZKit/**/*.{png,jpg,jpeg,gif,xml,json,plist,xib,bundle}'
        ss.frameworks   = 'Foundation'
        ss.frameworks   = 'UIKit'
        ss.dependency     'SDWebImage'
        ss.dependency     'Masonry'
        ss.dependency     'ReactiveObjC'
        ss.dependency     'Typeset'
        ss.dependency     'OpenUDID'
        ss.dependency     'YYModel'
    end
    
end
