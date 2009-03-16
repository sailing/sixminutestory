class Share < ActiveRecord::Base
  acts_as_rated :with_stats_table => true, :stats_class => RatingsStatistic
  belongs_to :user
end
