require 'data_mapper'

DataMapper.setup(:default, ENV['DATABASE_URL'] || "postgres://postgres:123456@localhost/tfwdashboard")

class Visit
  include DataMapper::Resource
  property :id, Serial
  property :time_created, DateTime, :required => true
  property :time_start, DateTime
  property :time_end, DateTime
  property :male, Integer, :default => 0
  property :female, Integer, :default => 0
  property :revenue, Integer, :default => 0
  property :tips, Integer, :default => 0
  property :comment, String
  property :payed_by_card, Boolean, :default => false
  property :amount_payed_by_card, Integer
end

DataMapper.finalize
