class User
  include Mongoid::Document
  field :email, type: String
  field :password, type: String
  field :admin, type: Mongoid::Boolean

  embeds_many :lines , store_as :dashboard

  validates_presence_of :name, :email
  validates_uniqueness_of :email
end
