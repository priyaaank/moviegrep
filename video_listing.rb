SUPPOURTED_EXTENSIONS = ["avi", "mp4", "mkv"]

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

  def smart_organize
    videos.each do |video|
      video.lookup_ratings
    end
  end

  private

  def file_name_pattern
    base_string = "**/*{"
    (SUPPOURTED_EXTENSIONS.inject("#{@path_for_movies}/**/*{") { |str, value|  str + ".#{value}," }.chop) + "}"
  end

end
