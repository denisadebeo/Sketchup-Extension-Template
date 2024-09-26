module Adebeo::ExtensionName
    class << self
      # Main method to set up the toolbar and associated UI elements
      def toolbar
        @extension_name = self.to_s.split("::").last
        current_path = __dir__.dup.tap { |path| path.force_encoding('UTF-8') if path.respond_to?(:force_encoding) }

        # Load toolbar configurations from JSON files in the current directory
        toolbar_files = Dir.glob(File.join(current_path, "*.json"))
        toolbars = toolbar_files.map { |file| { name: File.basename(file, '.json').capitalize, json_file: file } }

        # Set up each toolbar defined in the JSON files
        toolbars.each do |toolbar|
          setup_toolbar(toolbar)
        end
      end

      private

      # Set up a single toolbar with its commands, menu items, and context menu
      def setup_toolbar(toolbar)
        # Load the toolbar configuration from the JSON file
        cmd_of_extension = Adebeo.get_hash_from_json_file(toolbar[:json_file])

        # Set up various UI elements
        setup_menu(cmd_of_extension, toolbar[:name])
        setup_reloader
        setup_toolbar_ui(cmd_of_extension, toolbar[:name])
        setup_context_menu(cmd_of_extension, toolbar[:name])
        create_commands(cmd_of_extension)
        create_options_command
      end

      # Set up the menu for the extension
      def setup_menu(cmd_of_extension, toolbar_name)
        menu_items = cmd_of_extension.select { |_, v| v[:isMenu] == true }
        @plugins_menu = UI.menu("Plugins").add_submenu(toolbar_name) if menu_items.any? || IS_DEVELOPMENT
      end

      def setup_reloader
        puts "setup_reloader IS_DEVELOPMENT: #{IS_DEVELOPMENT}"
        # Add a reload command if in development mode
        return unless IS_DEVELOPMENT
        create_command({
          name: "reload",
          description: "Reload All Files",
          command: "Adebeo::ExtensionName.reload",
          submenu: @plugins_menu,
          is_menu: true
        })

      end

      # Set up the toolbar UI
      def setup_toolbar_ui(cmd_of_extension, toolbar_name)
        toolbar_items = cmd_of_extension.select { |_, v| v[:isToolbar] == true }
        @toolbar = UI::Toolbar.new(toolbar_name) if toolbar_items.any?
      end

      # Set up the context menu
      def setup_context_menu(cmd_of_extension, toolbar_name)
        context_items = cmd_of_extension.select { |_, v| v[:isContext] == true }
        return unless context_items.any?

        cmd_contexts = context_items.transform_values { |v| v[:command] }

        UI.add_context_menu_handler do |context_menu|
          submenu = context_menu.add_submenu(toolbar_name)
          cmd_contexts.each do |description, cmd|
            submenu.add_item(description) { eval(cmd) }
          end
        end
      end

      # Create commands for all items in the configuration
      def create_commands(cmd_of_extension)
        cmd_of_extension.each do |key, value|
          spec = {
            name: key.to_s,
            description: value[:description],
            command: value[:command],
            submenu: @plugins_menu,
            toolbar: @toolbar,
            is_menu: value[:isMenu],
            is_toolbar: value[:isToolbar],
            is_context: value[:isContext]
          }
          create_command(spec)
        end
      end

      # Create a command for accessing user options
      def create_options_command
        extension_name = self.to_s.downcase.gsub("::", "_")
        command_line = "#{self.to_s}::get_user_options(true)"
        create_command({
          name: "option",
          description: "Set user options",
          command: command_line,
          submenu: @plugins_menu
        })
      end

      # Create a single command based on the provided specification
      def create_command(spec)
        cmd = UI::Command.new(spec[:description]) { eval(spec[:command]) }

        setup_toolbar_icon(cmd, spec) if spec[:toolbar] && spec[:is_toolbar]
        setup_menu_item(cmd, spec) if spec[:submenu] && spec[:is_menu]

        cmd
      end

      # Set up the toolbar icon for a command
      def setup_toolbar_icon(cmd, spec)
        toolbar_extension = PLUGIN::MAC ? "pdf" : "svg"
        icon_path = File.join(PLUGIN::PLUGIN_PATH, "icons", "#{spec[:name]}.#{toolbar_extension}")

        if File.exist?(icon_path)
          cmd.small_icon = cmd.large_icon = icon_path
        else
          # Fallback to PNG icons if vector format is not available
          cmd.small_icon = File.join(PLUGIN::PLUGIN_PATH, "icons", "#{spec[:name]}_SM.png")
          cmd.large_icon = File.join(PLUGIN::PLUGIN_PATH, "icons", "#{spec[:name]}_BG.png")
        end

        cmd.tooltip = spec[:name]
        cmd.menu_text = spec[:name]
        cmd.status_bar_text = spec[:description]
        spec[:toolbar].add_item(cmd)
      end

      # Set up a menu item for a command
      def setup_menu_item(cmd, spec)
        cmd.menu_text = spec[:description]
        spec[:submenu].add_item(cmd)
      end
    end
  end
