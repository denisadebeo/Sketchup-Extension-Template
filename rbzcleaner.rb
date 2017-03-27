
adebeoRubyPath = File.dirname(__FILE__)
extensionRubyfiles = Dir.glob("#{adebeoRubyPath}/*.rbz")
extensionRubyfiles.each{|file|
	system "zip -d #{file} __MACOSX/\\*"
 	system "zip -d #{file} *.DS_Store"
}