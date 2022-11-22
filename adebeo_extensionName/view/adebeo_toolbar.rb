=begin

All command and toolabar are defint in cmdInToolBar.json 
If you set a isToolbar to true You must puts icons files:
-> 64x64 pixel png file  "icon/#{NAMEOFTHEFUNCTION}_BG.png"
-> 32x32 pixel png file  "icon/#{NAMEOFTHEFUNCTION}_SM.png"

{
    'cmd1': # Name of the function
    {
        'description':'description', #description of the function
        'command':'controler', #name of the controler, the new class that will be created inside controler folder
        'isMenu':true, if the the cmd is present inside a Menu
        'isToolbar':true, if the the cmd is present inside a toolbar
        'isContext':true  if the the cmd is present inside a right clic
    },
    'cmd2', .....   
}

=end

module Adebeo::ExtensionName
    def self.toolbar() 

        #get the extension name
        @extensionName = self.to_s.split("::").last


        current_path = __dir__.dup
        current_path.force_encoding('UTF-8') if current_path.respond_to?(:force_encoding)


        toolbar_file = Dir.glob("#{current_path}/*.json")
        toolbars = toolbar_file.map{|file| {:name=>File.basename(file, '.json').capitalize,:json_file=>file} }

        toolbars.each{|toolbar|
            cmdOfExtension = Adebeo::getHashFromJsonFile toolbar[:json_file]

            #create menu if needed
            arrayOdIsMenu = cmdOfExtension.select{|k,v| v[:isMenu] ==true}
            @plugins_menu = UI.menu("Plugins").add_submenu(toolbar[:name]) if (arrayOdIsMenu.length > 0 or ISDEVELLOPPEMENT)
            
            #create toolbar if needed
            arrayOdIsToolbar = cmdOfExtension.select{|k,v| v[:isToolbar] ==true}
            @toolbar = UI::Toolbar.new toolbar[:name] if arrayOdIsToolbar.length >0     
            
            #create context if needed
            arrayOdIsContext = cmdOfExtension.select{|k,v| v[:isContext] ==true}

            #create all commande
            cmd_contexts = {}
            cmdOfExtension.each do |k,v|
                spec = {
                    :name => k.to_s,
                    :description => v[:description],
                    :command=> "#{v[:command]}"
                }
                spec[:submenu] = @plugins_menu if v[:isMenu]
                spec[:toolbar] = @toolbar if v[:isToolbar]
                spec[:subContextMenu] = v[:isContext] if v[:isContext]

                cmdAdebeo = createCommand(spec)
                if v[:isContext]
                    cmd_contexts[v[:description]] = "#{v[:command]}"
                end
            end


            if arrayOdIsContext.length > 0
                UI.add_context_menu_handler do |context_menu|
                    subcontextmenu = context_menu.add_submenu(toolbar[:name])
                    cmd_contexts.each{|description,cmdAdebeo|
                        subcontextmenu.add_item(description) {eval(cmdAdebeo)}
                    }
                end
            end

            # create option command in menu 
            extenionName = self.to_s.downcase.gsub("::","_")
            commandLine = "#{self.to_s}::getUserOptions(true)"
            spec = {
                    :name => "option",
                    :description=>"set user option",
                    :command=>commandLine,
                    :submenu=>@plugins_menu
                }
            createCommand(spec)  

            # if develloppement mode create a reloader for controler
            if ISDEVELLOPPEMENT
                @extenionName = self.to_s.downcase.gsub("::","_")


                current_path = __dir__.dup
                current_path.force_encoding('UTF-8') if current_path.respond_to?(:force_encoding)

                lib = "#{current_path}/../adebeo_library.rb"
                folders = ["#{current_path}/../controlers/**/*.rb","#{current_path}/../models/**/*.rb"]
                files_to_be_reloadeds = folders.map{|p| Dir.glob(p)}.flatten
                files_to_be_reloadeds << lib
                commandLine = "#{files_to_be_reloadeds}.each{|f| load f};SKETCHUP_CONSOLE.clear()"
                spec = {
                        :name => "reload",
                        :description=>"Reload All File",
                        :command=>commandLine,
                        :submenu=>@plugins_menu
                    }
                createCommand(spec)      
            end

        }

    end
  
    def self.createCommand(spec)
        #puts "create command"
        #puts spec.inspect
        #iS_OSX = Sketchup.platform == :platform_osx
        #iS_OSX ? cursorExtension ="pdf" : cursorExtension ="png"
        description = spec[:description]
        cmdAdebeo = UI::Command.new(description){
          eval(spec[:command])
        }
        if spec[:toolbar]
            Adebeo::ExtensionName::MAC ? toolbar_extension ="pdf" : toolbar_extension ="svg"
            vertoriel_path = File.join(Adebeo::ExtensionName::PLUGIN_PATH,"icon","#{spec[:name]}.#{toolbar_extension}")
            if File.exist? vertoriel_path
                cmdAdebeo.small_icon = vertoriel_path
                cmdAdebeo.large_icon = vertoriel_path
            else
                toolbar_extension ="png"
                cmdAdebeo.small_icon = File.join(Adebeo::ExtensionName::PLUGIN_PATH,"icon","#{spec[:name]}_SM.#{toolbar_extension}")
                cmdAdebeo.large_icon = File.join(Adebeo::ExtensionName::PLUGIN_PATH,"icon","#{spec[:name]}_BG.#{toolbar_extension}")
            end
            cmdAdebeo.tooltip = spec[:description]
            toolbar = spec[:toolbar].add_item cmdAdebeo
        end
        if spec[:submenu]
            cmdAdebeo.menu_text = spec[:description]
            spec[:submenu].add_item(cmdAdebeo)
        end

        return cmdAdebeo

    end

end