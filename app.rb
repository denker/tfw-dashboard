require 'sinatra'
require 'sinatra/flash'
require 'sinatra/partial'
require "sinatra/json"
require 'slim'

require 'htmlentities' # for html special symbols in views

set :partial_template_engine, :slim

require './rubies/helpers'
require './rubies/models' # file with require DataMapper and decriptions of all models
require './rubies/visits' # contorollers for Visit model and /visits/ views
require './rubies/history'
require './rubies/stats'

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

get '/data.json/' do
  td = Date.today
  sd = build_work_date(td.year, td.month, td.day) - 31
  hash = {
    labels: [],
    datasets: [ {
        fillColor: "rgba(210, 210, 210, 0.2)",
        strokeColor: "rgba(185, 185, 185, 1)",
        pointColor: "rgba(199, 169, 149, 1)",
        pointStrokeColor: "#fff",
        pointHighlightFill: "#fff",
        pointHighlightStroke: "rgba(205, 162, 151, 1)",
        data: []
      } ]
    }
  30.times do |i|
    sd += 1
    hash[:labels] << sd.strftime('%d.%m.%Y')
    r = Visit.all(:started_at.gt => sd, :started_at.lt => sd + 1).sum(:revenue)
    hash[:datasets].first[:data] << r.to_i
  end
  json hash
end

get '/reports/' do
  slim :reports
end
