class Story < ApplicationRecord
	belongs_to :prompt, counter_cache: true
end
