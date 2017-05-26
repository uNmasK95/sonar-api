class Metric
  include Mongoid::Document

  field :name, type: String
  belongs_to :zone
  belongs_to :sensor

  embedded_in :graphic

  validates_presence_of :zone, :sensor, :on => :create


end
