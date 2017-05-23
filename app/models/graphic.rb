class Graphic
  include Mongoid::Document

  embeds_many :metrics
  embedded_in :line

end
