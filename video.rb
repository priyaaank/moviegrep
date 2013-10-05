SERIES_PATTERNS = [/(.*)[\s.-]{1,}(s\d{1,}.e\d{1,}).*(mp4|avi|mkv)/i, /(.*)(\d{1,}x\d{1,}).*(mp4|avi|mkv)/i, /(.*)(season\d{1,}?episode\d{1,}).*(mp4|avi|mkv)/i].collect {|r| SeriesRegex.new(r) }
MOVIE_PATTERNS = [MovieRegex.new(/([\d\s\w\.-]+).*(\d{4})[\]\)]{0,}.*\.(avi|mp4|mkv|flv)/i), MovieRegex.new(/([\d\w\s]+).*(avi|mp4|mkv|flv)/i, 1, 3, 2)]

class Video

  SPECIAL_CHARACTERS = ["[", "]", ".", "-", "_", "(", ")"]
  @@imdb_service = ImdbService.new
  @@organizer = VideoOrganizer.new
  attr_accessor :filepath, :basename, :type, :name, :year, :extension, :imdb_rating, :imdb_id

  def initialize(filename)
    @filepath = filename
    @basename = File.basename(filename)
    extract_name
  end

  def extract_name
    MOVIE_PATTERNS.each do |pattern|
      if pattern.matches?(@basename)
        @name = cleaned_up(pattern.name)
        @year = pattern.year
        @extension = pattern.extension
        puts "done : #{@name}"
        break
      end
    end
  end

  def lookup_ratings
    @@imdb_service.lookup self
  end

  def display_name
    [@name, @year, @imdb_id].reject{ |e| e.nil? || e.strip.empty? }.compact.join("-").gsub(" ","")
  end

  def organize
    @@organizer.organize self
  end

  private

  def cleaned_up text
    text_clone = text
    SPECIAL_CHARACTERS.each { |char| text_clone.gsub!(char, " ") }
    text_clone.gsub!("  "," ")
    text_clone
  end

end
