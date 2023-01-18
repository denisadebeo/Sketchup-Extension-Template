adebeoFileExtensionName = "adebeo_extensionName"

module Adebeo
  module ExtensionName
	ISDEVELLOPPEMENT = true
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
# SELECTE SERVER
#$adebeoServerPath =  'http://localhost:3000'

["rb","rbe"].each{|extension|
  extensionRubyfiles = Dir.glob("#{adebeoRubyPath}/**/*.#{extension}")
  extensionRubyfiles.each{|file|
  	Sketchup::require file if ![File.basename(adebeoRubyfile, adebeoRubyExtensions)].include? File.basename(file, adebeoRubyExtensions)
  }
}

if not file_loaded?(adebeoFileExtensionName+"#{adebeoRubyExtensions}")
 if Adebeo::ExtensionName::ISDEVELLOPPEMENT
 	Sketchup.send_action "showRubyPanel:"
 end
 Adebeo::ExtensionName::toolbar
end

file_loaded("#{adebeoFileExtensionName}#{adebeoRubyExtensions}")