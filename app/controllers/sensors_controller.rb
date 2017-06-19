require 'httparty'

class SensorsController < ApplicationController
  include HTTParty

  before_action :is_admin, only: [ :create, :update, :destroy ]
  before_action :set_zone
  before_action :set_sensor, only: [ :show, :update, :destroy ]
  before_action :set_sensor_id, only: [ :state, :turnOn, :turnOff, :timerate ]

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
    response_register = register_sensor
    # if response_register != nil
      json_response({ sensor: @sensor, state: response_register })
    # else
    #   @sensor.destroy
    #   json_response({ sensor: @sensor, state: 'cant conect to hostname' } , 404)
    # end

  end

  # PATCH/PUT /zones/1/sensors/1
  def update
    local_sensor_params = sensor_params
    if @sensor.update( sensor_params )
      turnOff if not local_sensor_params[:hostname].blank?
      response_register = register_sensor
      # if response_register == nil
      #   json_response({ sensor: @sensor, state: 'cant conect to hostname' } , 404)
      # end
      json_response({ sensor: @sensor, state: response_register }) #unless response_register != nil
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
    begin
      response = HTTParty.get(@sensor.hostname + '/state')
      json_response( response.body )
    rescue Errno::ECONNREFUSED
      json_response( { state: 'error on state' } , 404)
    end
  end

  def timerate
    begin
      response = HTTParty.post(
        @sensor.hostname + '/rate',
        body: {
            rate: params[:rate] || 30,
        })
      json_response( response.body )
    rescue Errno::ECONNREFUSED
      json_response( { state: 'error on timerate' } , 404)
    end
  end

  def turnOn
    begin
      response = HTTParty.post(@sensor.hostname + '/turnOn',body: {})
      json_response(response.body )
    rescue Errno::ECONNREFUSED
      json_response( { state: 'error on turnOn' } , 404)
    end
  end

  def turnOff
    begin
      response = HTTParty.post(@sensor.hostname + '/turnOff',body: {})
      json_response(response.body )
    rescue Errno::ECONNREFUSED
      json_response( { state: 'error on turnOff' } , 404)
    end
  end

  private
  def set_zone
    @zone = Zone.find(params[:zone_id])
  end

  def set_sensor
    @sensor = @zone.sensors.find(params[:id])
  end

  def set_sensor_id
    @sensor = @zone.sensors.find(params[:sensor_id])
  end

  # Only allow a trusted parameter "white list" through.
  def sensor_params
    params.permit(:hostname, :name, :description, :min, :max, :latitude, :longitude)
  end

  def register_sensor
    begin
      response = HTTParty.post(
          @sensor.hostname + '/register',
          body: {
              url: 'http://' + request.env['REMOTE_ADDR'] + ':3000',
              zone: @zone.id.to_s,
              sensor: @sensor.id.to_s,
              rate: params[:rate] || 5,
      })
      return response.body
    rescue Errno::ECONNREFUSED
      return nil
    end
  end

  def is_admin
    if not admin?
      raise(ExceptionHandler::AdminAuthenticationError, Message.not_admin )
    end
  end

end
