Pod::Spec.new do |s|
    s.name         = 'layoutCompleteChecker'
    s.version      = '1.0.0'
    s.summary      = 'help you checking layoutComplete'
    s.homepage     = 'https://github.com/huanshijiushiniu/layoutCompleteChecker'
    s.license      = 'MIT'
    s.authors      = {'zhengzhiwen' => '597706108@qq.com'}
    s.platform     = :ios, '6.0'
    s.source       = {:git => 'https://github.com/huanshijiushiniu/layoutCompleteChecker.git', :tag => s.version}
    s.source_files = 'layoutCompleteChecker/**/*.{h,m}'
    s.requires_arc = true
end
