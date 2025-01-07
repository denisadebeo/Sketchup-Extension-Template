module Adebeo::ExtensionName
  def self.reload
    folders = [
      "#{PLUGIN_PATH}/models/**/*.rb",
      "#{PLUGIN_PATH}/observers/**/*.rb",
      "#{PLUGIN_PATH}/overlays/**/*.rb",
      "#{PLUGIN_PATH}/toolbars/**/*.rb",
      "#{PLUGIN_PATH}/tools/**/*.rb",
      "#{PLUGIN_PATH}/utils/**/*.rb",
    ]
    files_to_be_reloadeds = folders.map{|p| Dir.glob(p)}.flatten
    files_to_be_reloadeds << "#{PLUGIN_PATH}/adebeo_library.rb"
    files_to_be_reloadeds.each{|f|
      load f
    }
    SKETCHUP_CONSOLE.clear()
  end
end
