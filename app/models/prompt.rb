class Prompt < ApplicationRecord
	has_many :stories

  def self.random
    Prompt.first
    # write a sql query to get a random prompt that's been verified
    # and where use_on is not null, so it won't grab a future prompt
    # if that even matters anymore
  end
end
