class Color < ActiveRecord::Base
  has_many :color_urls
  has_many :urls, through: :color_urls
end
