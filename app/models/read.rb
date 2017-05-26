class Read
  include Mongoid::Document
  field :value, type: Float
  field :timestamp, type: Integer

  belongs_to :zone
  belongs_to :sensor

  validates_presence_of :zone, :sensor, :value, :timestamp, :on => :create

end
