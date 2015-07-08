source 'http://rubygems.org'

gem 'rails', '~> 4.2'
gem 'sqlite3'

# We <3 New Relic
gem 'newrelic_rpm'

# Deploy with Capistrano
gem 'capistrano'
gem 'capistrano-rails'
gem 'capistrano-rvm'

# Basic i18n's
gem 'rails-i18n'

# CAS support
gem 'rack-cas'

# Photo management
gem 'paperclip', '~> 4.3'

# Responders
gem 'responders', '~> 2.0'

# Better OpenURI with redirections
gem 'open_uri_redirections'

# Better forms
gem 'formtastic'

# Pagination
gem 'will_paginate', '~> 3.0'

# Send error messages
gem 'exception_notification', '~> 4.0'

# ActiveRecord enhancements
gem 'acts_as_list'

# Easy http requests
gem 'httparty'

# M$-love
gem 'spreadsheet'

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

# Ansicolor
gem 'term-ansicolor'

# Errbit
gem 'airbrake'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails', '~> 4.0'
  gem 'oily_png'                        # Faster PNG generation for compass sprites
  gem 'jquery-rails'
  gem 'uglifier'                        # Javascript compressor
  gem 'therubyracer'       # Javascript engine
end

group :development do
  # Annotations are nice and pretty
  gem 'annotate'

  gem 'rails-erd'
end

group :production do
  gem 'mysql2'          # Database
end

group :development, :test do
  gem 'pry-byebug'
end
