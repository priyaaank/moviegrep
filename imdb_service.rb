require 'net/http'
require 'json'

class ImdbService

  URL = 'http://www.omdbapi.com/?'
  MOVIE_NAME = "t=##movie_name##"
  YEAR = "y=##year##"

  def lookup video
    params = MOVIE_NAME.gsub("##movie_name##", video.name)
    params = params + "&" + YEAR.gsub("##year##", video.year) unless (video.year.nil? || video.year.empty?)
    encoded_params = URI::encode(params)
    url = URL + encoded_params
    update_movie_details_from url, video
  end

  private

  def update_movie_details_from url, video
    response = Net::HTTP.get_response(URI.parse(url))
    data = JSON.parse(response.body)
    video.imdb_rating = data["imdbRating"]
    video.imdb_id = data["imdbId"]
    video.organize
  end

end
