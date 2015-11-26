require './rainbow_bandit'
require './lib/rainbow_scraper'
require 'sinatra/activerecord/rake'

task :scrape, :n do |t, args|
  (args[:n] || 1).to_i.times { RainbowScraper.new.execute }
end
