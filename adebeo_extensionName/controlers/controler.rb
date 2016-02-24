module Adebeo::ExtensionName
	class Controler
		attr_accessor
		def initialize()
			@model = Sketchup.active_model
			@definitions = @model.definitions
			@options = Adebeo::ExtensionName::getUserOptions()
			puts @options.inspect
		end
	end
end