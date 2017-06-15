require 'httparty'

class SensorsController < ApplicationController
  include HTTParty

  before_action :is_admin, only: [ :create, :update, :destroy ]
  before_action :set_zone
  before_action :set_sensor, only: [ :show, :update, :destroy, :state, :timerate ]

  # GET /zones/1/sensors
  def index
    @sensors = @zone.sensors.all
    json_response( @sensors )
  end

  # GET /zones/1/sensors/1
  def show
    json_response( @sensor )
  end

  # POST /zones/1/sensors
  def create
    local_sensors_params = sensor_params
    @sensor = @zone.sensors.create!(
        hostname: local_sensors_params[:hostname],
        name: local_sensors_params[:name],
        description: local_sensors_params[:description],
        min: local_sensors_params[:min] || @zone.min,
        max: local_sensors_params[:max] || @zone.max,
        latitude: local_sensors_params[:latitude],
        longitude: local_sensors_params[:longitude]
    )

    register_sensor

    json_response( @sensor )
  end

  # PATCH/PUT /zones/1/sensors/1
  def update
    if @sensor.update(sensor_params)
      json_response( @sensor )
    else
      json_response( @sensor.errors, :unprocessable_entity )
    end
  end

  # DELETE /zones/1/sensors/1
  def destroy
    @sensor.destroy
    head :no_content
  end

  def state
    response = HTTParty.get(@sensor.hostname + '/state')
    json_response( response.body )
  end

  def timerate
    response = HTTParty.post(
      @sensor.hostname + '/rate',
      body: {
          rate: params[:rate] || 30,
      })
    json_response( response.body )
  end

  def turnOn
    HTTParty.post(@sensor.hostname + '/turnOn',body: {})
    json_response(response.body )
  end

  def turnOff
    HTTParty.post(@sensor.hostname + '/turnOff',body: {})
    json_response(response.body )
  end

  private
  def set_zone
    @zone = Zone.find(params[:zone_id])
  end

  def set_sensor
    @sensor = @zone.sensors.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def sensor_params
    params.permit(:hostname, :name, :description, :min, :max, :latitude, :longitude)
  end

  def register_sensor
    HTTParty.post(
        @sensor.hostname + '/register',
        body: {
            url: 'http://' + request.env['REMOTE_ADDR'] + ':3000/reads',
            zone: @zone.id.to_s,
            sensor: @sensor.id.to_s,
            rate: params[:rate] || 30,
    })
  end

  def is_admin
    if not admin?
      raise(ExceptionHandler::AdminAuthenticationError, Message.not_admin )
    end
  end

end
