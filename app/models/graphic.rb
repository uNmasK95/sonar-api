class Graphic
  include Mongoid::Document

  field :name, type: String
  field :rangeTime, type: Integer, default: 0

  embeds_many :metrics
  embedded_in :line

end
