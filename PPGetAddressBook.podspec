
Pod::Spec.new do |s|

  s.name         = "PPGetAddressBook"
  s.version      = "0.2.6"
  s.summary      = "一行代码极速获取通讯录联系人,并进行A~Z精准排序"

  s.homepage     = "https://github.com/jkpang/PPGetAddressBook.git"

  s.license      = { :type => "MIT", :file => "LICENSE" }

  s.author       = { "jkpang" => "jkpang@outlook.com" }
  
  s.platform     = :ios, "7.0"

  s.source       = { :git => "https://github.com/jkpang/PPGetAddressBook.git", :tag => s.version.to_s }

  s.source_files  = "PPGetAddressBook/PPGetAddressBook/*.{h,m}"

  s.requires_arc = true

end
