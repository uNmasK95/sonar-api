class Line
  include Mongoid::Document

  embeds_many :graphics
  embedded_in :user

end
