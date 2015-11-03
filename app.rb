require 'sinatra'
require 'slim'

# file with require DataMapper and decriptions of all models
require './datamapper_models'

# contorollers for Visit model and /visits/ views
require './visits'

get '/' do
  today = Date.today
  date_delimeter = Time.new(today.year, today.month, today.day, 12, 0)
  date_start = Time.now >= date_delimeter ? date_delimeter : date_delimeter - 86400
  dm_params = { :time_start.gte => date_start, :time_start.lt => date_start + 86400 }

  @total = Visit.sum(:revenue, dm_params).to_i
  @guests = Visit.sum(:male, dm_params).to_i + Visit.sum(:female, dm_params).to_i
  @checks = Visit.count(:revenue, dm_params)

  slim :index
end
