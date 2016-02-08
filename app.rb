require 'sinatra'
require 'sinatra/flash'
require 'sinatra/partial'
require "sinatra/json"
#require "sinatra/streaming"
require 'slim'

require 'htmlentities' # for html special symbols in views

set :partial_template_engine, :slim

require './rubies/xlsx'
require './rubies/helpers'
require './rubies/models' # file with require DataMapper and decriptions of all models
require './rubies/visits' # contorollers for Visit model and /visits/ views
require './rubies/history'
require './rubies/stats'
require './rubies/reports'

before do
  headers 'Content-Type' => 'text/html; charset=utf-8'
  @nav = [ %w(/visits/ Today), %w(/history/ History), %w(/stats/ Stats), %w(/reports/ Reports) ]
end

get %r{(/.*[^\/])$} do
  redirect "#{params[:captures].first}/"
end

get '/' do
  redirect to('/visits/')
end
