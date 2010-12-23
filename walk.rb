#!/usr/bin/ruby
require 'open-uri'
require './last_fm'

def local_dirs 
  (Dir.entries('.') - ['.', '..']).find_all { |x| File.directory? x }
end

start = ARGV[0] || '/mnt/epsilon/music/mp3'

Dir.chdir start do
  local_dirs.each do |artist|
    Dir.chdir artist do
      local_dirs.each do |album|
        Dir.chdir album do
          next if File.exists? 'cover.jpg'
          next if File.exists? 'cover.png'

          puts "> #{artist} - #{album}"

          coverurl = fetch_cover(artist, album)
          puts "< #{coverurl}"
          next unless coverurl

          ext = File.extname coverurl
          cover = 'cover' + ext
          puts "= #{cover}"

          open(cover, 'wb') do |file|
            open(coverurl) do |url|
              file.write(url.read)
            end
          end 

          next if ext == '.jpg'
          puts "X convert #{cover} cover.jpg"
          `convert #{cover} cover.jpg ; rm #{cover}`
        end
      end
    end
  end
end

