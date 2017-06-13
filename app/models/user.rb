class User
  include Mongoid::Document
  include ActiveModel::SecurePassword

  field :email, type: String
  field :password_digest, type: String
  has_secure_password
  field :admin, type: Mongoid::Boolean, default: false

  embeds_many :lines

  validates_presence_of :email, :password, :on => :create
  validates_uniqueness_of :email
end
