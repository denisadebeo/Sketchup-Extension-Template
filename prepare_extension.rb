require 'fileutils'

editeur = "Adebeo".capitalize
extensionName = "Elongator".capitalize
description = "Scretch your component"

editeur_c = editeur.gsub(" ","_")
extensionName_c = extensionName.gsub(" ","_")
editeur_module = editeur_c.capitalize
extensionName_module = extensionName_c.capitalize

#crer le fichier
current_path = File.dirname(__FILE__)
current_extension_path = "#{current_path}/#{editeur_c}_#{extensionName_c}_extension"

if File.exist? current_extension_path
	FileUtils.rm_rf(current_extension_path)
end

Dir::mkdir(current_extension_path)

#copy le dossiers et le fichiers
main_sub_folder_path = File.join(current_extension_path,"#{editeur_c}_#{extensionName_c}")
FileUtils.copy_entry "adebeo_extensionName", main_sub_folder_path

main_extension_file = File.join(current_extension_path,"#{editeur_c}_#{extensionName_c}.rb")
FileUtils.cp "adebeo_extensionName.rb", main_extension_file

sub_main_extension_file_source = File.join(main_sub_folder_path,"adebeo_extensionName.rb")
sub_main_extension_file = File.join(main_sub_folder_path,"#{editeur_c}_#{extensionName_c}.rb")
File.rename sub_main_extension_file_source, sub_main_extension_file

conf_file = File.join(main_sub_folder_path,"conf","adebeo_extensionName_configuration.rb")
new_conf_file = File.join(main_sub_folder_path,"conf","#{editeur_c}_#{extensionName_c}_configuration.rb")
File.rename(conf_file, new_conf_file)

# ext = SketchupExtension.new 'extensionName','adebeo_extensionName/adebeo_extensionName.rb'

# modifie le fichier principale
text = File.read(main_extension_file)
new_contents = text.gsub("adebeo_extensionName/adebeo_extensionName.rb", "#{editeur_c}_#{extensionName_c}/#{editeur_c}_#{extensionName_c}.rb")
new_contents = new_contents.gsub("adebeo", editeur)
new_contents = new_contents.gsub("Adebeo", editeur_c)
new_contents = new_contents.gsub("extensionName", extensionName)
new_contents = new_contents.gsub("ExtensionName", extensionName_c)
new_contents = new_contents.gsub("2024", Time.new.year.to_s)
new_contents = new_contents.gsub("description!", description)
new_contents = new_contents.gsub("Adebeo::ExtensionName", "#{editeur_c}::#{extensionName_c}")
new_contents = new_contents.gsub("AdebeoExtensionName.strings", "#{editeur_c}#{extensionName_c}.strings")


File.open(main_extension_file, "w") {|file| file.puts new_contents }

model_file = File.join(main_sub_folder_path,"models","cube.rb")
observer_file = File.join(main_sub_folder_path,"observers","adebeo_extension_observer.rb")
overlay_file = File.join(main_sub_folder_path,"overlays","cubes_overlay.rb")
lib_file = File.join(main_sub_folder_path,"adebeo_library.rb")
tool_bar_file = File.join(main_sub_folder_path,"toolbars","adebeo_toolbar.rb")
tool_file = File.join(main_sub_folder_path,"tools","tool.rb")
reloader_file = File.join(main_sub_folder_path,"utils","reloader.rb")
cmd_json = File.join(main_sub_folder_path,"toolbars","toolbarAndCmd.json")
#adebeo_extensionName_file = File.join(main_sub_folder_path,"adebeo_extensionName.rb")

# Modifie le nom du module
file_where_module_name_changes = [
	tool_file,
	model_file,
	overlay_file,
	observer_file,
	lib_file,
	tool_bar_file,
	cmd_json,
	new_conf_file,
	sub_main_extension_file,
	reloader_file
]
file_where_module_name_changes.each{|file_where_module_name_change|
	puts file_where_module_name_change if !File.exist? file_where_module_name_change
	text = File.read(file_where_module_name_change)
	new_contents = text.gsub("adebeo_extensionName","#{editeur_c}_#{extensionName_c}")
	new_contents.gsub!("Adebeo",editeur_module)
	new_contents.gsub!("ExtensionName",extensionName_module)

	File.open(file_where_module_name_change, "w") {|file| file.puts new_contents }
}

toolbar_file = File.join(main_sub_folder_path,"toolbars","toolbarAndCmd.json")
new_toolbar_file = File.join(main_sub_folder_path,"toolbars","#{extensionName_c}.json")
File.rename(toolbar_file, new_toolbar_file)
