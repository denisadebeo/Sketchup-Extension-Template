adebeoFileExtensionName = "adebeo_extensionName"

Sketchup::require 'sketchup'
Sketchup::require 'json'

module Adebeo
  module ExtensionName

  end
end

adebeoRubyPath = File.dirname(__FILE__)

# REMOVE EXTENSION BEFORE SCRUMBLE
adebeoRubyExtensions = File.extname(__FILE__)
#$adebeoRubyExtensions = ""

#Set to false before Prod
isDevelloppement = true


# SELECTE SERVER
#$adebeoServerPath =  'http://localhost:3000'

extensionRubyfiles = Dir.glob("#{adebeoRubyPath}/**/*.rb")
extensionRubyfiles.each{|file|
	Sketchup::require file if ![File.basename(__FILE__, adebeoRubyExtensions)].include? File.basename(file, adebeoRubyExtensions)
}

extensionRubyfiles = Dir.glob("#{adebeoRubyPath}/**/*.rbs")
extensionRubyfiles.each{|file|
	Sketchup::require file if ![File.basename(__FILE__, adebeoRubyExtensions)].include? File.basename(file, adebeoRubyExtensions)
}




if not file_loaded?(adebeoFileExtensionName+"#{adebeoRubyExtensions}")
 if isDevelloppement
 	Sketchup.send_action "showRubyPanel:"
 end
 Adebeo::ExtensionName::toolbar(isDevelloppement)
end

file_loaded("#{adebeoFileExtensionName}#{adebeoRubyExtensions}")