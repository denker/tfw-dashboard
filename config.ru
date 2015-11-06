require 'bundler'
Bundler.require
require './app'

#DataMapper.setup(:default, ENV['DATABASE_URL'] || "postgres://postgres:123456@localhost/tfwdashboard")

run Sinatra::Application
