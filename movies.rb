DEFAULT_FILE_PATH = 'movies.txt'
DEFAULT_MOVIE_NAME = 'Max'

Movie = Struct.new(:url, :name, :year, :country, :release_date, 
                   :genre, :running_time, :rating, :director, :stars) do
  
  MAX_RATING_FRACTION = 9

  def rating_fraction
    rating.split('.')[1]&.to_i
  end

  def rating_stars
    '*' * rating_fraction + ' ' * (MAX_RATING_FRACTION - rating_fraction)  
  end                
end

def parse_movie_info(file_line)
  movie_info = file_line.chomp.split('|')
  Movie.new(*movie_info)
end

entered_file_path = ARGV.first || ''

file_path = if File.exist?(entered_file_path)
              entered_file_path
            else
              ARGV.clear
              puts 'File not found'
              puts 'Use default file? (yes or no)'
              exit if gets[0] =~ /n/
              DEFAULT_FILE_PATH
            end

movies = File.readlines(file_path).map { |line| parse_movie_info(line) }

rating_list = movies.find_all{ |movie| movie.name =~ /#{DEFAULT_MOVIE_NAME}/ }
                    .sort_by(&:rating).reverse

rating_list.each do |movie|
  p "#{movie.rating_stars} | #{movie.name}"
end