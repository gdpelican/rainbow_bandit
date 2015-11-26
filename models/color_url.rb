class ColorUrl < ActiveRecord::Base
  belongs_to :color
  belongs_to :url
end
