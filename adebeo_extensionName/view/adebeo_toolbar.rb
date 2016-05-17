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
  
    def self.toolbar(isDevelloppement) 

        #get the extension name
        extensionName = self.to_s.split("::").last

        #get command definition from the json inside cmdInToolBar.json
        cmdOfExtension = Adebeo::getHashFromJsonFile "#{File.dirname(__FILE__)}/toolbarAndCmd.json"

        #create menu if needed
        arrayOdIsMenu = cmdOfExtension.select{|k,v| v[:isMenu] ==true}
        @plugins_menu = UI.menu("Plugins").add_submenu(extensionName) if (arrayOdIsMenu.length > 0 or isDevelloppement)
        
        #create toolbar if needed
        arrayOdIsToolbar = cmdOfExtension.select{|k,v| v[:isToolbar] ==true}
        @toolbar = UI::Toolbar.new extensionName if arrayOdIsToolbar.length >0     
        
        #create context if needed
        arrayOdIsContext = cmdOfExtension.select{|k,v| v[:isContext] ==true}
        if arrayOdIsToolbar.length >0
            UI.add_context_menu_handler do |context_menu|
                @subContextMenu = context_menu.add_submenu(extensionName)
            end
        end

        #create all commande
        cmdOfExtension.each do |k,v|
            spec = {
                :name => k.to_s,
                :description => v[:description],
                :command=> "#{v[:command]}"
            }
            spec[:submenu] = @plugins_menu if v[:isMenu]
            spec[:toolbar] = @toolbar if v[:isToolbar]
            spec[:subContextMenu] = @subContextMenu if v[:isContext]
            createCommand(spec)
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
        if isDevelloppement
            extenionName = self.to_s.downcase.gsub("::","_")
            p = "#{File.dirname(__FILE__)}/../controlers/**/*.rb"
            commandLine = "Dir.glob('#{p}').each{|f| load f}"
            spec = {
                    :name => "reload",
                    :description=>"Reload All File",
                    :command=>commandLine,
                    :submenu=>@plugins_menu
                }
            createCommand(spec)        
        end

    end
  
    def self.createCommand(spec)
        puts "create command"
        puts spec.inspect
        description = spec[:description]
        cmdAdebeo = UI::Command.new(description){
          eval(spec[:command])
        }
        if spec[:toolbar]
            cmdAdebeo.tooltip = spec[:description]
            cmdAdebeo.small_icon = "../icon/#{spec[:name]}_SM.png"
            cmdAdebeo.large_icon = "../icon/#{spec[:name]}_BG.png"
            toolbar = spec[:toolbar].add_item cmdAdebeo
        end
        if spec[:submenu]
            cmdAdebeo.menu_text = spec[:description]
            spec[:submenu].add_item(cmdAdebeo)
        end
        if spec[:subContextMenu]
            spec[:subContextMenu].add_item(spec[:description]){
                eval(spec[:command])
            }
        end
    end

end