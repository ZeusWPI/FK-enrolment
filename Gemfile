source 'http://rubygems.org'

gem 'rails', '~> 3.1.0'

# Bundle edge Rails instead:
# gem 'rails',     :git => 'git://github.com/rails/rails.git'

gem 'sqlite3'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails', '~> 3.1.0'
  gem 'compass', '~> 0.12.alpha.0'
  gem 'oily_png' # Faster PNG generation for compass sprites
  gem 'jquery-rails'
  gem 'uglifier'
  gem 'therubyracer' # Javascript engine
end

# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'

# CAS support
gem 'rubycas-client', git: 'git://github.com/Javache/rubycas-client.git', branch: 'master'
gem 'rubycas-client-rails', :git => 'git://github.com/Javache/rubycas-client-rails.git'

# Photo management
gem 'paperclip', '~> 2.3.15'

# Better forms
gem 'formtastic'

# Pagination
gem 'will_paginate', '~> 3.0'

# Dutch messages
gem 'rails-i18n'

# Send error messages
gem 'exception_notification', :require => 'exception_notifier'

# ActiveRecord enhancements
gem 'acts_as_list'

# Easy http requests
gem 'httparty'

group :production do
  gem 'mysql2'
end

group :test do
  # Pretty printed test output
  gem 'turn', :require => false
  gem 'autotest-rails'
end
