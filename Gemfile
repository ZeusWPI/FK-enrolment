source 'http://rubygems.org'

gem 'rails', '~> 4.2'

# Protected attributes to ease the migration
gem 'protected_attributes'

# We <3 New Relic
gem 'newrelic_rpm'

# Cool decent working icons
gem 'font-awesome-sass'

# Deploy with Capistrano
gem 'capistrano'
gem 'capistrano-rails'
gem 'capistrano-rvm'
gem 'capistrano-rbenv'

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

# Whenever
gem 'whenever'

# Asset gems (not in the asset group, see
# http://stackoverflow.com/a/17221248/1068495
gem 'sass-rails', '~> 4.0'
gem 'oily_png'                        # Faster PNG generation for compass sprites
gem 'jquery-rails'
gem 'uglifier'                        # Javascript compressor
gem 'therubyracer'       # Javascript engine

group :development do
  gem 'sqlite3'

  gem 'annotate'

  gem 'rails-erd'

  gem 'puma'
end

group :production do
  gem 'mysql2'          # Database
end

group :development, :test do
  gem 'pry-rails'
  gem 'pry-byebug'
end
