require 'data_mapper'

DataMapper.setup(:default, ENV['DATABASE_URL'] || "postgres://postgres:123456@localhost/tfwdashboard")
DataMapper::Property::String.length(255)

class Visit
  include DataMapper::Resource
  property :id, Serial
  property :time_created, DateTime, :required => true
  property :time_start, DateTime
  property :time_end, DateTime
  property :male, Integer, :default => 0
  property :female, Integer, :default => 0
  property :revenue, Integer, :default => 0
  property :bycard, Integer, :default => 0
  property :tips, Integer, :default => 0
  property :comment, String
end

DataMapper.finalize
