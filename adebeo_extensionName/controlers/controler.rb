module Adebeo::ExtensionName
	class Controler
		attr_accessor
		def initialize()
			@model = Sketchup.active_model
			@definitions = @model.definitions
			puts Adebeo::ExtensionName::getUserOptions()
		end
	end
end