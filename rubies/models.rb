require 'data_mapper'

DataMapper.setup(:default, ENV['DATABASE_URL'] || "mysql://test:123456@localhost/testdb")
#DataMapper.setup(:default, ENV['DATABASE_URL'] || "postgres://postgres:123456@localhost/tfw")
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
  property :age, String, :default => '--'
  property :if_snacks, Boolean
  property :if_hot_meal, Boolean
  property :if_first_visit, Boolean
  property :comment, String
end

DataMapper.finalize
