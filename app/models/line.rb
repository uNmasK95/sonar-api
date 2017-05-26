class Line
  include Mongoid::Document

  field :name, type: String

  embeds_many :graphics
  embedded_in :user

end
