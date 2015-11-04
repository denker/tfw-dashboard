require 'sinatra'
require 'slim'

require './helpers'
require './models' # file with require DataMapper and decriptions of all models
require './visits' # contorollers for Visit model and /visits/ views

get '/stats/day/:year/:month/:day' do |year, month, day|
  @view_type = 'day' # month, week, day
  work_date = Time.new(year, month, day, 12, 0)
  @prev_link = prev_link(type, work_date)
  @next_link = next_link(type, work_date)
  @period = "#{day}.#{month}.#{year}"
  dm_params = { :time_start.gte => work_date, :time_start.lt => work_date + 86400 }

  @total = Visit.sum(:revenue, dm_params).to_i
  @guests = Visit.sum(:male, dm_params).to_i + Visit.sum(:female, dm_params).to_i
  @checks = Visit.count(:revenue, dm_params)

  slim :index
end
