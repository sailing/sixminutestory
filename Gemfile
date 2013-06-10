source :rubygems
source :gemcutter

# ruby '1.9.2'
# Stack
gem 'rails', '3.2.13'
gem 'thin'

# Analytics
gem 'newrelic_rpm'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

group :assets do
  gem 'sass-rails'
  gem 'coffee-rails'
  gem 'uglifier'
  gem 'font-awesome-rails'
  gem 'less-rails'
  gem 'twitter-bootstrap-rails', :git => 'git://github.com/seyhunak/twitter-bootstrap-rails.git'

  # asset_sync moves files to s3, where they're served by cloudfront
  gem "asset_sync"

  # superspeeds asset precompilation
  gem 'turbo-sprockets-rails3'
end

# Layout and scripting

gem 'jquery-rails'
gem 'haml-rails'

gem 'rinku', :require => 'rails_rinku' # replacing auto_linking in rails 3.2

# user authing
gem 'authlogic', '>= 3.1'
gem 'rpx_now'
gem 'authlogic_rpx', :git => 'git://github.com/sailing/authlogic_rpx.git'

# caching
# for Heroku
# dalli is a caching replacement for memcached
gem 'dalli'


#voting tool
gem 'thumbs_up', '>= 0.3.2'

#permalinks are handled by friendly_id
gem 'friendly_id', '~> 3.1'

#pagination
# gem "will_paginate", "~> 3.0"
gem 'kaminari'

#flickr api for prompts
gem 'flickraw'

#for reading flickr responses
gem 'json'

# tagging
  gem 'acts-as-taggable-on'

# recaptcha
gem 'recaptcha'



group :development, :test do
  gem 'sqlite3-ruby', :require => 'sqlite3'
  gem "therubyracer"
  # To use debugger

  # taps is for database syncing on heroku
  gem 'taps', '>= 0.3.22'

  # gem 'bullet'
  # gem 'rack-mini-profiler'

end

group :production do

  gem 'pg'

end