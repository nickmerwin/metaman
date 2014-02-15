require "thor"
require "thor/group"
require "mini_exiftool_vendored"

module Metaman
  class CLI < Thor
    include Thor::Actions

    desc 'extract', "Extract meta"
    def extract(root='.', output_path='keywords.csv')
      puts "Writing to #{output_path}"
      csv = File.open(output_path, 'w')
      csv.write "Filename, Caption, Keywords, Artist, Copyright\n"

      Dir["#{root}/**/*"].each do |path|
        next if ['.','..'].include?(path)

        meta = MiniExiftool.new(path) rescue next

        file = File.basename path

        unless meta.keywords.nil?
            puts "=> #{file}"
          csv.write "#{file}, #{meta.imagedescription}, #{meta.keywords.join ';'}, #{meta.artist}, #{meta.copyright}\n"
        end
      end

      puts "Done!"
      csv.close
    end
    default_task :extract
  end
end
