require 'bundler'
Bundler.require
require './app'

DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite3://#{Dir.pwd}/development.db")

run Sinatra::Application
