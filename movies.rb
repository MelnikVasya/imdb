file_path = ARGV.first || 'movies.txt'

abort 'File not found' unless File.exist?(file_path)

rating_list = File.open(file_path, 'r')
                  .map { |movie| movie.split('|') }
                  .find_all { |movie| movie[1].include?('Max') }
                  .sort_by { |movie| movie[7] }.reverse

max_name_length = rating_list.map { |movie| movie[1].length }.max

rating_list.each do |movie|
  name = movie[1].ljust(max_name_length)
  stars = '*' * ((movie[7].to_f - 8) / 0.1).round

  puts "#{name} #{stars}"
end
