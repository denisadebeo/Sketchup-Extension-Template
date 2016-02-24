  require 'sketchup.rb'
  require 'extensions.rb'

  # Create the extension.
  ext = SketchupExtension.new 'extensionName','adebeo_extensionName/adebeo_extensionName.rb'

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