source :rubygems
source :gemcutter

gem 'rails', '3.2.5'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

group :assets do
  gem 'sass-rails'
  gem 'coffee-rails'
  gem 'uglifier'
  gem 'twitter-bootstrap-rails', :git => 'https://github.com/seyhunak/twitter-bootstrap-rails.git'
  gem 'less'
end

# user authing
gem 'authlogic', '>= 3.1'
gem 'rpx_now'
gem 'authlogic_rpx', :git => 'git://github.com/sailing/authlogic_rpx.git'

# caching
# for Heroku
# dalli is a caching replacement for memcached
gem 'dalli'
# asset_sync moves files to s3, where they're served by cloudfront
gem "asset_sync"

# taps is for database syncing on heroku
gem 'taps', '>= 0.3.22'

#voting tool 
gem 'thumbs_up', '>= 0.3.2'

#permalinks are handled by friendly_id
gem 'friendly_id', '~> 3.1'

#pagination
gem "will_paginate", "~> 3.0.pre2"

#haml
gem 'haml', '3.1.2'

#flickr api for prompts
gem 'flickraw'

#for reading flickr responses
gem 'json'

# jQuery is the default JavaScript library in Rails 3.1
gem 'jquery-rails'

# tagging
  gem 'acts-as-taggable-on'

# recaptcha
  gem 'recaptcha'

# Replacing auto_link
gem 'rinku', '~> 1.5.0', :require => 'rails_rinku'

# Bundle the extra gems:
# gem 'bj'
# gem 'nokogiri'
# gem 'sqlite3-ruby', :require => 'sqlite3'
# gem 'aws-s3', :require => 'aws/s3'



# Bundle gems for the local environment. Make sure to
# put test-only gems in this group so their generators
# and rake tasks are available in development mode:

group :development, :test do
  gem 'sqlite3-ruby', :require => 'sqlite3'
  # To use debugger
  # gem 'ruby-debug-base19x'

end

group :production do

  gem 'pg'
  gem 'thin'
  gem 'newrelic_rpm'
end