Dir["**/*.rb"].each {|file| require "./#{file}" if file != 'moviegrep.rb' }

PATH_FOR_MOVIES="/Source/Directory/For/Movies/"

videos= VideoListing.new(PATH_FOR_MOVIES)
videos.build_list
videos.smart_organize
