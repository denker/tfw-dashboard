require 'data_mapper'

DataMapper.setup(:default, ENV['DATABASE_URL'] || "mysql://test:123456@localhost/testdb")
DataMapper::Property::String.length(255)

class Visit
  include DataMapper::Resource
  property :id, Serial
  property :created_at, DateTime, :required => true # TODO change name to :created_at
  property :updated_at, DateTime
  property :started_at, DateTime
  property :finished_at, DateTime # TODO add validation for finished_at > started_at
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

  before :valid? do
    attribute_set(:created_at, DateTime.now) if attribute_get(:created_at).nil?
    attribute_set(:updated_at, DateTime.now)
  end

end

DataMapper.finalize
