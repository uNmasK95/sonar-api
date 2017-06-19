class NotificationSerializer < ActiveModel::Serializer
  attributes :id, :min, :max, :value, :timestamp, :description, :sensor

  belongs_to :zone , serializer: ZoneNotificationSerializer


  def sensor
    puts object.sensor_id
    ZoneNotificationSerializer.new(object.zone.sensors.find(object.sensor_id)).attributes
  end


  has_many :users
end
