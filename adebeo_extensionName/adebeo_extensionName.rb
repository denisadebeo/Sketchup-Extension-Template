# Constants
EXTENSION_NAME = "adebeo_extensionName"
SUPPORTED_EXTENSIONS = ["rb", "rbe"]

module Adebeo
  module ExtensionName

    LH = LanguageHandler.new("messages.strings").freeze

    #OS
    MAC = ((Object::RUBY_PLATFORM =~ /darwin/i) ? true : false).freeze
    WIN = (!MAC).freeze

    # x86 vs x64
    PLATFORM_IS_64BIT = (Sketchup.respond_to?(:is_64bit?) && Sketchup.is_64bit?).freeze
    PLATFORM_IS_32_BIT = (!PLATFORM_IS_64BIT).freeze

    # File extension for cursor
    CURSOR_EXTENSION = MAC ? "pdf": "svg"

    # Get the plugin path and ensure UTF-8 encoding
    PLUGIN_PATH = __dir__.dup.tap do |path|
      path.force_encoding('UTF-8') if path.respond_to?(:force_encoding)
    end.freeze

    # Check if we're in development mode
    IS_DEVELOPMENT = (File.extname(__FILE__) == ".rb").freeze

    # standard vectors
    REDV = Geom::Vector3d.new(1, 0, 0).freeze
    GREENV = Geom::Vector3d.new(0, 1, 0).freeze
    BLUEV = Geom::Vector3d.new(0, 0, 1).freeze
    ORIGIN = Geom::Point3d.new(0, 0, 0).freeze
    KEY_DELETE = 8.freeze

  end
end

# Get the current file path and ensure UTF-8 encoding
current_file = __FILE__.dup
current_file.force_encoding('UTF-8') if current_file.respond_to?(:force_encoding)

# Load all Ruby files in the plugin directory, except the current file
SUPPORTED_EXTENSIONS.each do |extension|
  Dir.glob(File.join(Adebeo::ExtensionName::PLUGIN_PATH, "**", "*.#{extension}")).each do |file|
    next if File.basename(file, ".*") == File.basename(current_file, ".*")
    Sketchup.require file
  end
end

# Run this block only if the extension hasn't been loaded yet
unless file_loaded?("#{EXTENSION_NAME}.#{File.extname(__FILE__)}")
  # Show Ruby panel if in development mode
  Sketchup.send_action "showRubyPanel:" if Adebeo::ExtensionName::IS_DEVELOPMENT

  # Initialize the extension's toolbar
  Adebeo::ExtensionName.toolbar

  # Mark the extension as loaded
  file_loaded("#{EXTENSION_NAME}#{File.extname(__FILE__)}")
end
