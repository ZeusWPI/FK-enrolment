source 'http://rubygems.org'

gem 'rails', '~> 3.1.0.rc'

# Bundle edge Rails instead:
# gem 'rails',     :git => 'git://github.com/rails/rails.git'

gem 'sqlite3'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails', "~> 3.1.0.rc"
  gem 'compass', git: 'git://github.com/chriseppstein/compass.git', branch: 'rails31'
  gem 'uglifier'
  gem 'jquery-rails'

  # Uglifier dependencies
  gem 'execjs'
  gem 'therubyracer'
end

# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'

# CAS support
gem 'rubycas-client', git: 'git://github.com/Javache/rubycas-client.git', branch: 'master'
gem 'rubycas-client-rails', :git => "git://github.com/zuk/rubycas-client-rails.git"

# Photo management
gem "paperclip", "~> 2.3.15"

# Better forms
gem 'formtastic'

# Dutch messages
gem 'rails-i18n'

# Send error messages
gem 'exception_notification', :require => 'exception_notifier'

group :production do
  gem 'mysql2'
end

group :test do
  # Pretty printed test output
  gem 'turn', :require => false
  gem 'autotest-rails'
  gem 'ZenTest', '~> 4.5.0'
end
