require 'data_mapper'

DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite3://#{Dir.pwd}/development.db")

class Visit
  include DataMapper::Resource
  property :id, Serial
  property :time_start, DateTime, :required => true
  property :time_end, DateTime
  property :male, Integer
  property :female, Integer
  property :revenue, Integer
  property :tips, Integer, :default => 0
  property :comment, String
  property :payed_by_card, Boolean, :default => false
  property :amount_payed_by_card, Integer
end

class Test
  include DataMapper::Resource
  property :id, Serial
  property :text, String
end

DataMapper.finalize
