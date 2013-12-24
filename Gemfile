source 'http://rubygems.org'

gem 'rails', '~> 3.2'
gem 'sqlite3'

# We <3 New Relic
gem 'newrelic_rpm'

# Deploy with Capistrano
# gem 'capistrano'

# CAS support
gem 'rubycas-client', git: 'git://github.com/Javache/rubycas-client.git', branch: 'master'
gem 'rubycas-client-rails', :git => 'git://github.com/Javache/rubycas-client-rails.git'

# Photo management
gem 'paperclip', '~> 2.7'

# Better forms
gem 'formtastic', '~> 2.2'

# Pagination
gem 'will_paginate', '~> 3.0'

# Dutch messages
gem 'rails-i18n'

# Send error messages
gem 'exception_notification', '~> 4.0'

# ActiveRecord enhancements
gem 'acts_as_list'

# Easy http requests
gem 'httparty'

# M$-love
gem 'spreadsheet'

# Creating zip-files nice and easy
gem 'zippy'

# Creating datagrids
gem 'datagrid'

# Larger, more CPU-intensive jobs
gem 'daemons'         # Running delayed_job
gem 'delayed_job', '~> 4.0'
gem 'delayed_job_active_record'

# eID-integration
gem 'ruby-saml'

# SOAP
gem 'savon'

# Moved outside :assets group since we reference it in application.rb
gem 'compass-rails'


# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails', '~> 3.2'
  gem 'oily_png'                        # Faster PNG generation for compass sprites
  gem 'jquery-rails', '~> 2.1'
  gem 'uglifier'                        # Javascript compressor
  gem 'therubyracer', '~> 0.12.0'       # Javascript engine
  gem 'yui-compressor', '~> 0.11.0'
end

group :development do
  # Annotations are nice and pretty
  gem 'annotate'

  gem 'thin'
  # To use debugger
  # gem 'ruby-debug19', :require => 'ruby-debug'
  gem 'term-ansicolor'
  gem 'rails-erd'
end

group :production do
  gem 'mysql2'          # Database
  gem 'unicorn'         # Webserver
end

group :test do
  gem 'minitest', '~> 4.0'
  gem 'turn'                  # Pretty printed test output
  gem 'cover_me', '~> 1.2.0'  # Code coverage
end
