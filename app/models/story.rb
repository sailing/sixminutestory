class Story < ApplicationRecord
	has_one :prompt, inverse_of: :stories
end
