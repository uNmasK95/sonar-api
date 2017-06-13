class NotificationSerializer < ActiveModel::Serializer
  attributes :id, :zone, :sensor, :value, :timestamp, :min, :max, :description

  has_many :users

end
