require 'sinatra'
require 'slim'
require 'data_mapper'

DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite3://#{Dir.pwd}/development.db")

class Visit
  include DataMapper::Resource
end

DataMapper.finalize

get '/' do
  
end
