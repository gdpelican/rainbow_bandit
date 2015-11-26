class Url < ActiveRecord::Base
  has_many :color_urls
  has_many :colors, through: :color_urls
end
