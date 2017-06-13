class Sensor
  include Mongoid::Document

  field :hostname, type: String
  field :name, type: String
  field :description, type: String
  field :min, type: Integer, default: 0
  field :max, type: Integer, default: 100
  field :latitude, type: Float, default: 0
  field :longitude, type: Float, default: 0

  embedded_in :zones

  validates_presence_of :name, :description, :on => :create

end
