
Pod::Spec.new do |s|

  s.name         = "PPGetAddressBook"
  s.version      = "0.2.8"
  s.summary      = "一句代码极速获取按A~Z分组精准排序的通讯录联系人 OC版( 已处理姓名所有字符的排序问题 )"

  s.homepage     = "https://github.com/jkpang/PPGetAddressBook.git"

  s.license      = { :type => "MIT", :file => "LICENSE" }

  s.author       = { "jkpang" => "jkpang@outlook.com" }
  
  s.platform     = :ios, "7.0"

  s.source       = { :git => "https://github.com/jkpang/PPGetAddressBook.git", :tag => s.version.to_s }

  s.source_files  = "PPGetAddressBook/PPGetAddressBook/*.{h,m}"

  s.requires_arc = true

end
