#create gif and light gif
require 'fileutils'
dir = "#{File.dirname(__FILE__)}/*" #/


extension_directori = Dir.glob(dir).select { |fn| File.directory?(fn) }

extension_directori.each{|current_path|
	current_path
	Dir.glob("#{current_path}/**/*.rb").each{|rbPath|
		puts rbPath
		system("./Scrambler #{rbPath}")
		File.delete rbPath
	}
}