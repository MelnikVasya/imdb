require 'csv'
require 'ostruct'

file_path = ARGV.first || 'movies.txt'

abort 'File not found' unless File.exist?(file_path)

MOVIE_ATTRIBUTES = %i(url name year country release_date genre
                      running_time rating director stars).freeze

movies_list = CSV.open(file_path, col_sep: '|').map do |movie_info|
  OpenStruct.new(MOVIE_ATTRIBUTES.zip(movie_info).to_h)
end

def print_movies(movies)
  movies.each do |movie|
    puts "#{movie.name} (#{movie.release_date}; "\
         "#{movie.genre.tr(',', '/')}) - #{movie.running_time}"
  end
end

five_longest_movies = movies_list.sort_by { |movie| movie.running_time.to_i }
                                 .reverse.first(5)

ten_comedies = movies_list.find_all { |movie| movie.genre.include?('Comedy') }
                          .sort_by(&:release_date).first(10)

all_films_directors = movies_list.map(&:director).uniq
                                 .sort_by { |director| director.split.last }

made_outside_usa = movies_list.count { |movie| movie.country != 'USA' }

puts '1. Five longest movies'

print_movies(five_longest_movies)

puts '', '2. Ten comedies'

print_movies(ten_comedies)

puts '', '3. All films directors'

all_films_directors.each { |director| puts director }

puts '', "4. #{made_outside_usa} films made outside the USA"

puts '', '5. Monthly Statistics'

movies_list.find_all { |movie| movie.release_date.length > 5 }
           .group_by { |movie| Date.strptime(movie.release_date, '%Y-%m').month }
           .sort_by(&:first)
           .each { |month, movies| puts "In #{Date::MONTHNAMES[month]} #{movies.count} movies filmed." }
