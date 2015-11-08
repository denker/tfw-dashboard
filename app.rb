require 'sinatra'
require 'sinatra/partial'
require 'slim'

set :partial_template_engine, :slim

require './rubies/helpers'
require './rubies/models' # file with require DataMapper and decriptions of all models
require './rubies/visits' # contorollers for Visit model and /visits/ views
require './rubies/stats'

get %r{(/.*[^\/])$} do
  redirect "#{params[:captures].first}/"
end
