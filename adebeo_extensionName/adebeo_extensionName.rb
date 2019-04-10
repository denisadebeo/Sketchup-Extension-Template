adebeoFileExtensionName = "adebeo_extensionName"

module Adebeo
  module ExtensionName

  end
end


adebeoRubyPath = __dir__.dup
adebeoRubyPath.force_encoding('UTF-8') if adebeoRubyPath.respond_to?(:force_encoding)

adebeoRubyfile = __FILE__.dup
adebeoRubyfile.force_encoding('UTF-8') if adebeoRubyfile.respond_to?(:force_encoding) 

# REMOVE EXTENSION BEFORE SCRUMBLE
adebeoRubyExtensions = File.extname(adebeoRubyfile)
#$adebeoRubyExtensions = ""

#Set to false before Prod
isDevelloppement = true


# SELECTE SERVER
#$adebeoServerPath =  'http://localhost:3000'

extensionRubyfiles = Dir.glob("#{adebeoRubyPath}/**/*.rb")
extensionRubyfiles.each{|file|
	Sketchup::require file if ![File.basename(adebeoRubyfile, adebeoRubyExtensions)].include? File.basename(file, adebeoRubyExtensions)
}

extensionRubyfiles = Dir.glob("#{adebeoRubyPath}/**/*.rbs")
extensionRubyfiles.each{|file|
	Sketchup::require file if ![File.basename(adebeoRubyfile, adebeoRubyExtensions)].include? File.basename(file, adebeoRubyExtensions)
}




if not file_loaded?(adebeoFileExtensionName+"#{adebeoRubyExtensions}")
 if isDevelloppement
 	Sketchup.send_action "showRubyPanel:"
 end
 Adebeo::ExtensionName::toolbar(isDevelloppement)
end

file_loaded("#{adebeoFileExtensionName}#{adebeoRubyExtensions}")