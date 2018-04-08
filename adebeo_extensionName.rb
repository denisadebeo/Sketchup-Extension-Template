  Sketchup::require 'sketchup'
  Sketchup::require 'extensions'
  # Create the extension.
  
  current_path = File.dirname(__FILE__)
  extension_path = File.join(current_path,"adebeo_extensionName","adebeo_extensionName.rb")
  if File.exist? extension_path
    ext = SketchupExtension.new('extensionName', extension_path)
  else
    extension_path = File.join(current_path,"adebeo_extensionName","adebeo_extensionName.rbs")
    ext = SketchupExtension.new('extensionName',extension_path)
  end
  # Attach some nice info.
  ext.creator     = 'adebeo, Inc.'
  ext.version     = '0.0.0'
  ext.copyright   = '2016 adebeo, Inc.'
  ext.description = 'adebeo description!'

  #SKETCHUP_CONSOLE.show

  # Register and load the extension on startup.
  Sketchup.register_extension ext, true

=begin
0.0.0

=end