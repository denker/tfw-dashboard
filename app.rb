require 'sinatra'
require 'sinatra/partial'
require 'slim'

require 'htmlentities' # for html special symbols in views

set :partial_template_engine, :slim

require './rubies/helpers'
require './rubies/models' # file with require DataMapper and decriptions of all models
require './rubies/visits' # contorollers for Visit model and /visits/ views
#require './rubies/history'
#require './rubies/stats'

before do
  @nav = [ %w(/visits/ Today), %w(/history/ History), %w(/stats/ Stats), %w(/reports/ Reports) ]
end

get %r{(/.*[^\/])$} do
  redirect "#{params[:captures].first}/"
end

get '/' do
  @nav = [ [" "] ]
  slim :main
end

get '/reports/' do
  redirect to '/visits/'
  #slim :reports
end

get '/history/*' do
  slim :dummy_history
end

get '/stats/' do
  redirect to '/visits/'
end
