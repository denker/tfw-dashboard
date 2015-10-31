require 'sinatra'
require 'slim'
require './datamapper_models' # file with require DataMapper and decriptions of all models

get '/' do
  @visits = Visit.all
  slim :index
end

post '/' do
  puts params[:visit]
  visit = Visit.new params[:visit]
  visit.time_start = Time.now
  visit.save
  redirect to('/')
end
