require 'sinatra'
require 'sinatra/activerecord'
require './models/color'
require './models/color_url'
require './models/url'

get '/' do
  erb :form
end

get '/fetch' do
  @color = "##{params[:hex]}"
  @urls = Color.find_or_initialize_by(hex: @color).urls
  erb :urls
end
