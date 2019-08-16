
Pod::Spec.new do |s|
  s.name          = "CWLog"
  s.version       = "1.0.2"
  s.summary       = "Tool : swift项目中接口返回数据带中文,在控制栏显示unicode编码问题.使用该工具类可以正常展示中文"
  s.swift_version = '4.0'
  s.homepage     = "https://github.com/baozoudiudiu/CWSwiftPrint"

  # ―――  Spec License  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.license = { :type => "Apache-2.0", :file => "LICENSE" }
  # ――― Author Metadata  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.author = { "baozoudiudiu" => "https://github.com/baozoudiudiu" }
  # ――― Platform Specifics ――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.platform = :ios, "8.0"
  # ――― Source Location ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.source = { :git => "https://github.com/baozoudiudiu/CWSwiftPrint.git", :tag => s.version }
  # ――― Source Code ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.source_files  = "CWLog/*.swift"
  # ――― Project Settings ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.requires_arc = true
end
