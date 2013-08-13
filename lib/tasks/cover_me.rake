namespace :cover_me do
  desc "Generates and opens code coverage report."
  task :report do
    require 'cover_me'
    CoverMe.complete!
  end
end
