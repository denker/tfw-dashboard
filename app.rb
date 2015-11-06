require 'sinatra'
require 'slim'

require 'date'

require './rubies/helpers'
require './rubies/models' # file with require DataMapper and decriptions of all models
require './rubies/visits' # contorollers for Visit model and /visits/ views

get %r{(/.*[^\/])$} do
  redirect "#{params[:captures].first}/"
end

get '/stats/' do
  date = DateTime.get_work_date
  redirect to "/stats/day/#{date.year}/#{date.month}/#{date.day}/"
end

get '/stats/:interval/:year/:month/:day/' do |interval, year, month, day|
  given_params = { interval: interval, year: year.to_i, month: month.to_i, day: day.to_i }
  valid_params = given_params.make_valid(interval, year, month, day)
  redirect stats_link(valid_params) if valid_params != given_params

  work_date = DateTime.new_date( valid_params[:year], valid_params[:month], valid_params[:day] )

  @interval = valid_params[:interval]

  @prev_link = stats_link(@interval, work_date.start_of_prev(@interval))
  @next_link = stats_link(@interval, work_date.end_of(@interval))
  @interval_selector = interval_selector_links(work_date)
  @interval_title = interval_title(@interval, work_date)

  visit_params = { :time_start.gte => work_date,
                   :time_start.lt => work_date.end_of(@interval)}
  @total = Visit.sum(:revenue, visit_params).to_i
  @guests = Visit.sum(:male, visit_params).to_i + Visit.sum(:female, visit_params).to_i
  @checks = Visit.count(:revenue, visit_params)

  slim :stats
end
