require 'fileutils'

DESTINATION_DIRECTORY="/Destination/Directory/To/Save/Organized/Movies/"

class VideoOrganizer

  def initialize(destination_directory = DESTINATION_DIRECTORY)
    @destination_directory = destination_directory
    setup_destination_paths
  end

  def organize video
    folder_name = video.imdb_rating ? "ImdbRating#{video.imdb_rating.to_f.floor}/#{video.display_name}" : "ImdbRatingUnknown/#{video.name}"
    create_directory_if_doesnt_exists "#{@destination_directory}#{folder_name}"
    move_file video, video.filepath, "#{@destination_directory}#{folder_name}/#{video.basename}"
  end

  private

  def move_file video, source, destination
    puts "#{video.name}[#{video.imdb_rating}] :: #{source} to #{destination}"
    FileUtils.mv(source, destination)
  end

  def setup_destination_paths
    (1..10).each do |rating|
      create_directory_if_doesnt_exists "#{@destination_directory}ImdbRating#{rating}"
    end
    create_directory_if_doesnt_exists "#{@destination_directory}ImdbRatingUnknown"
  end

  def create_directory_if_doesnt_exists path
    FileUtils.mkdir_p(path)
  end

end
