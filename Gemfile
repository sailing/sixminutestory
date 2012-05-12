source 'http://rubygems.org'
source 'http://gemcutter.org'

gem 'rails', '3.1.3'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

group :assets do
  gem 'sass-rails',   "~> 3.1.5"
  gem 'coffee-rails', "~> 3.1.1"
  gem 'uglifier',     ">= 1.0.3"
end

# user authing
gem 'authlogic', '>= 3.1'
gem 'rpx_now'
gem 'authlogic_rpx', :git => 'git://github.com/sailing/authlogic_rpx.git'

#caching
#for Heroku
#dalli is a caching replacement for memcached
gem 'dalli'

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

# To use debugger
gem 'ruby-debug'

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
#   gem 'webrat'
end
