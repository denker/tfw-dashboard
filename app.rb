require 'sinatra'
require 'slim'

require 'date'

require './helpers'
require './models' # file with require DataMapper and decriptions of all models
require './visits' # contorollers for Visit model and /visits/ views

get '/test/:param' do |param|
  "#{param.to_i.class}"
end

get '/stats/' do
  date = current_work_date
  redirect to "/stats/day/#{date.year}/#{date.month}/#{date.day}"
end

get '/stats/:interval/:year/:month/:day' do |interval, year, month, day|
  valid_params = validate_stats_params(interval, year, month, day)
  if valid_params != {interval: interval, year: year.to_i, month: month.to_i, day: day.to_i}
    redirect to "/stats/#{valid_params[:interval]}/#{valid_params[:year]}/#{valid_params[:month]}/#{valid_params[:day]}"
  end

  work_date = DateTime.new( valid_params[:year],
                            valid_params[:month],
                            valid_params[:day],
                            12, 0, 0, '+3' )

  @interval = valid_params[:interval]
  interval_end = interval_end(@interval, work_date)

  @prev_link = stats_link(@interval, prev_interval_start(@interval, work_date))
  @next_link = stats_link(@interval, interval_end)
  @interval_options = interval_options(work_date)
  @interval_title = interval_title(@interval, work_date)

  dm_params = { :time_start.gte => work_date,
                :time_start.lt => interval_end}
  @total = Visit.sum(:revenue, dm_params).to_i
  @guests = Visit.sum(:male, dm_params).to_i + Visit.sum(:female, dm_params).to_i
  @checks = Visit.count(:revenue, dm_params)

  slim :stats
end
