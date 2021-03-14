require 'zip'

class ZipFileGenerator
  # Initialize with the directory to zip and the location of the output archive.
  def initialize(input_dir, output_file)
    @input_dir = input_dir
    @output_file = output_file
  end

  # Zip the input directory.
  def write
    entries = Dir.entries(@input_dir) - %w[. ..]

    ::Zip::File.open(@output_file, ::Zip::File::CREATE) do |zipfile|
      write_entries entries, '', zipfile
    end
  end

  private

  # A helper method to make the recursion work.
  def write_entries(entries, path, zipfile)
    entries.each do |e|
      zipfile_path = path == '' ? e : File.join(path, e)
      disk_file_path = File.join(@input_dir, zipfile_path)

      if File.directory? disk_file_path
        recursively_deflate_directory(disk_file_path, zipfile, zipfile_path)
      else
        put_into_archive(disk_file_path, zipfile, zipfile_path)
      end
    end
  end

  def recursively_deflate_directory(disk_file_path, zipfile, zipfile_path)
    zipfile.mkdir zipfile_path
    subdir = Dir.entries(disk_file_path) - %w[. ..]
    write_entries subdir, zipfile_path, zipfile
  end

  def put_into_archive(disk_file_path, zipfile, zipfile_path)
    zipfile.add(zipfile_path, disk_file_path)
  end
end


current_path = __dir__.dup
current_path.force_encoding('UTF-8') if current_path.respond_to?(:force_encoding)
directory_to_zip = current_path

rb_loader_path = Dir.glob(File.join(directory_to_zip,"Adebeo_*.rb"))&.first


output_file = File.basename(rb_loader_path).gsub("rb","rbz")
zf = ZipFileGenerator.new(directory_to_zip, output_file)
zf.write()

extensionRubyfiles = Dir.glob("#{current_path}/*.rbz")
extensionRubyfiles.each{|file|
	system "zip -d #{file} __MACOSX/\\*"
 	system "zip -d #{file} *.DS_Store"
 	system "zip -d #{file} rbzcleaner.rb"
 	system "zip -d #{file} *.git*"
}