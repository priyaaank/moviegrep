PATH_FOR_MOVIES="/Volumes/MY\ BOOK/Movies"
SUPPOURTED_EXTENSIONS = ["avi", "mp4", "mkv"]
MOVIE_PATTERNS = []

class SeriesRegex

  attr_accessor :current_name, :match_result

  def initialize(pattern, name_position = 1, season_n_episode_position = 2, extension_position = 3)
    @pattern = pattern
    @name_at_position = name_position
    @season_n_episode_at_position = season_n_episode_position
    @extension_at_position = extension_position
  end

  def matches?(name)
    @current_name = name
    @match_result = @current_name.match(@pattern)
    !@match_result.nil?
  end

  def name
    @match_result[@name_at_position]
  end

  def season_n_episode
    @match_result[@season_n_episode_at_position]
  end

  def extension 
    @match_result[@extension_at_position]
  end

end

class MovieRegex

  attr_accessor :current_name, :match_result

  def initialize(pattern, name_position = 1, year_position = 2, extension_position = 3)
    @pattern = pattern
    @name_at_position = name_position
    @year_at_position = year_position
    @extension_at_position = extension_position
  end

  def matches?(name)
    @current_name = name
    @match_result = @current_name.match(@pattern)
    !@match_result.nil?
  end

  def name
    @match_result[@name_at_position]
  end

  def year
    @match_result[@year_at_position]
  end

  def extension
    @match_result[@extension_at_position]
  end
end

SERIES_PATTERNS = [/(.*)[\s.-]{1,}(s\d{1,}.e\d{1,}).*(mp4|avi|mkv)/i, /(.*)(\d{1,}x\d{1,}).*(mp4|avi|mkv)/i, /(.*)(season\d{1,}?episode\d{1,}).*(mp4|avi|mkv)/i].collect {|r| SeriesRegex.new(r) }
MOVIE_PATTERNS = [/([\d\s\w\.-]+).*(\d{4})[\]\)]{0,}.*\.(avi|mp4|mkv|flv)/i].collect { |r| MovieRegex.new(r) } 

class Video

  SPECIAL_CHARACTERS = ["[", "]", ".", "-", "_"]
  attr_accessor :filepath, :basename, :type

  def initialize(filename)
    @filepath = filename
    @basename = File.basename(filename)
  end

  def print_pretty_name
    MOVIE_PATTERNS.each do |pattern|
      print_attributes_from(pattern) if pattern.matches?(@basename)
    end
  end

  def print_attributes_from pattern
    puts "*"*100
    puts "Details for filename: #{@basename}"
    puts "Name              : #{cleaned_up(pattern.name)}"
    puts "Year              : #{pattern.year}"
    puts "Extension         : #{pattern.extension}"
    puts "*"*100
  end

  private 

  def cleaned_up text
    text_clone = text
    SPECIAL_CHARACTERS.each { |char| text_clone.gsub!(char, " ") }
    text_clone.gsub!("  "," ")
    text_clone
  end

end

class VideoListing

  attr_accessor :videos

  def initialize(path)
    @path_for_movies = path
    @videos = []
  end

  def build_list
    file_name_pattern
    @videos = Dir.glob(file_name_pattern).collect { |filename| Video.new(filename) }
  end

  def sanitized_list
    @videos.each do |video|
      video.print_pretty_name
    end
  end

  private

  def file_name_pattern
    base_string = "**/*{"
    (SUPPOURTED_EXTENSIONS.inject("#{@path_for_movies}/**/*{") { |str, value|  str + ".#{value}," }.chop) + "}"
  end

end

videos= VideoListing.new(PATH_FOR_MOVIES)
videos.build_list
videos.sanitized_list
