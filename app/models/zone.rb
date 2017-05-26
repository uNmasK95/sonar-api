class Zone
  include Mongoid::Document

  field :name, type: String
  field :description, type: String
  field :type, type: Integer, default: 0
  field :min, type: Integer, default: 0
  field :max, type: Integer, default: 100

  embeds_many :sensors

  validates_presence_of :name, :description, :type, :min, :max , :on => :create

end
