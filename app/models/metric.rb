class Metric
  include Mongoid::Document
  field :rangeTime, type: Integer
  belongs_to :zone
  belongs_to :sensor

  embedded_in :graphic

end
