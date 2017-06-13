class Notification
  include Mongoid::Document
  field :min, type: Integer
  field :max, type: Integer
  field :value, type: Integer
  field :timestamp, type: String
  field :description, type: String

  belongs_to :zone
  belongs_to :sensor

  has_and_belongs_to_many :users

  validates_presence_of :zone, :sensor, :value, :timestamp, :on => :create

end
