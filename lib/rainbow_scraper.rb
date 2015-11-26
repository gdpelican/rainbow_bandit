require 'open-uri'
require 'nokogiri'
require './models/color'
require './models/url'
require 'byebug'
require 'screencap'

class RainbowScraper

  def execute
    exit 0 if Url.find_by(url: random_url)
    return unless random_url_body

    puts "Found #{random_url_stylesheet_colors} at #{random_url}"
    random_url_stylesheet_colors.map do |color|
      model_for_random_url.colors << Color.find_or_create_by(hex: color)
    end
    take_screenshot
  end

  private

  def random_url
    open('http://www.randomwebsite.com/cgi-bin/random.pl') { |response| @random_url = response.base_uri.to_s } unless @random_url
    @random_url
  rescue
    nil
  end

  def model_for_random_url
    @model_for_random_url ||= Url.create(url: random_url, title: random_url_body.title)
  end

  def random_url_body
    @random_url_body ||= Nokogiri::HTML(open(random_url))
  rescue
    puts "#{random_url} is not scrapeable"
  end

  def random_url_stylesheets
    @random_url_stylesheets ||= random_url_body.search('link').select { |link| link['type'] && link['type'].match(/css/) }
  end

  def random_url_style_tags
    @random_url_style_tags ||= random_url_body.search('style').select { |style| style['type'] && style['type'].match(/css/) }
  end

  def random_url_inline_styles
    @random_url_style_tags ||= random_url_style_tags.map { |style| style.to_s rescue '' }
  end

  def random_url_stylesheet_bodies
    @random_url_stylesheet_bodies ||= random_url_stylesheets.map do |stylesheet|
      href = stylesheet['href'].match(/^http/) ? stylesheet['href'] : [random_url, stylesheet['href']].join
      begin open(href).read rescue "" end
    end.join
  end

  def all_styles
    @all_styles ||= [random_url_stylesheet_bodies, random_url_inline_styles].flatten.join
  end

  def random_url_stylesheet_colors
    @random_url_stylesheet_colors ||= all_styles.scan(/#[A-F0-9]{6}/i).map(&:downcase).uniq
  end

  def take_screenshot
    File.open("public/screencaps/#{model_for_random_url.id}.jpg", "w") do |file|
      file.write Screencap::Fetcher.new(random_url).fetch(width: 100, height: 100)
      model_for_random_url.update(screencap: file.path.gsub(/^public/, ''))
    end
  end

end
