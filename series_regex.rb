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
