  Sketchup::require 'sketchup'
  Sketchup::require 'extensions'
  Sketchup::require 'json'
  # Create the extension.


  current_path = __dir__.dup
  current_path.force_encoding('UTF-8') if current_path.respond_to?(:force_encoding)

  extension_file = __FILE__.dup
  extension_file.force_encoding('UTF-8') if extension_file.respond_to?(:force_encoding)

  module Adebeo
    module ExtensionName
      VERSION = "1"
      PLUGIN = self
    end
  end

  unless file_loaded?(extension_file)

    extension_path = File.join(current_path,"adebeo_extensionName","adebeo_extensionName.rb")

    if !File.exist? extension_path
      extension_path = File.join(current_path,"adebeo_extensionName","adebeo_extensionName.rbe")
    end

    ext = SketchupExtension.new('extensionName',extension_path)
    # Attach some nice info.
    ext.creator     = 'adebeo, Inc.'
    ext.version     = Adebeo::ExtensionName::VERSION
    ext.copyright   = '2024 adebeo'
    ext.description = 'adebeo description!'

    #SKETCHUP_CONSOLE.show

    # Register and load the extension on startup.
    Sketchup.register_extension ext, true
  end

=begin
0.0.0

=end
