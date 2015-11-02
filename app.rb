require 'sinatra'
require 'slim'
require './datamapper_models' # file with require DataMapper and decriptions of all models

get '/visits' do
  @visits = Visit.all
  #@edit_id = 0
  slim :visits
end

get '/visits/:id' do
  @visits = Visit.all
  @edit_id = params[:id]
  slim :visits
end

post '/visits' do
  visit = Visit.new params[:visit]
  visit.time_start = Time.now
  visit.save
  redirect to('/visits')
end

put '/visits/:id' do
  visit = Visit.get(params[:id])
  visit.time_end = Time.now
  visit.attributes = params[:visit] # ТУТ НЕ РАБОТАЕТ!!!
  puts visit.id
  puts visit.save
  redirect to('/visits')
end

delete '/visits/:id' do
  visit = Visit.get(params[:id])
  visit.destroy!
  redirect to('/visits')
end
