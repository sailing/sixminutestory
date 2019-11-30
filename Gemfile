source 'https://rubygems.org'

ruby '2.5.7'

# Stack
gem 'rails', '~> 5.2.3'
gem 'puma'

# Persistence
gem 'pg'

# Analytics
gem 'honeybadger', '~> 4.0'
gem 'newrelic_rpm'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

group :assets do
  gem 'sass-rails'
  gem 'coffee-rails'
  gem 'uglifier'
  gem 'bootstrap', '~> 4.3.1'
  gem "bootswatch", github: "thomaspark/bootswatch"
  # asset_sync moves files to s3, where they're served by cloudfront
  # gem "asset_sync"

  # superspeeds asset precompilation
  gem 'sprockets-rails'
end

# Layout and scripting

gem 'jquery-rails'
gem 'haml-rails'

gem 'rinku', :require => 'rails_rinku' # replacing auto_linking in rails 3.2

# user authing
gem 'devise'
gem 'devise-encryptable'
gem 'simple_token_authentication', '~> 1.0'

# caching
# for Heroku
# dalli is a caching replacement for memcached
gem 'memcachier'
gem 'dalli'
gem 'activerecord-session_store'


# ancestry
gem 'ancestry'

#voting tool
gem 'thumbs_up', '>= 0.3.2'

#permalinks are handled by friendly_id
# gem 'friendly_id', '~> 5.2.4'

#pagination
# gem "will_paginate", "~> 3.0"
gem 'kaminari'

#flickr api for prompts
gem 'flickraw'

#for reading flickr responses
gem 'json', '>= 1.8.2'

# tagging
  gem 'acts-as-taggable-on'


group :development, :test do
  gem 'byebug'
  gem 'pry'
  gem 'rb-readline'
  gem 'rspec-rails'
  gem 'factory_bot_rails'
end