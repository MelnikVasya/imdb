DEFAULT_FILE_PATH = 'movies.txt'

file_path = if File.exist?(ARGV.first.to_s)
              ARGV.first
            elsif File.exist?(DEFAULT_FILE_PATH)
              puts 'Incorect entered file path or file not found. '\
                   'Program use default file.'
              DEFAULT_FILE_PATH 
            else
              puts 'File not found'
              exit
            end

rating_list = File.readlines(file_path)
                  .map { |movie| movie.split('|') }
                  .find_all { |movie| movie[1].include?('Max') }
                  .sort_by { |movie| movie[7] }.reverse

max_name_length = rating_list.map { |movie| movie[1].length }.max

rating_list.each do |movie|
  name = movie[1].ljust(max_name_length)
  stars = '*' * ((movie[7].to_f - 8) / 0.1).round

  puts "#{name} #{stars}"
end
