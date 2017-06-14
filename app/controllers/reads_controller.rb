class ReadsController < ApplicationController
  before_action :is_admin, only: [ :create ]
  before_action :check_params, :set_zone, :set_sensor

  # GET /reads
  def index
    # filter by last read_timestamp
    if not params[:timestamp].blank?
      @reads = Read.where(
          :zone => @zone,
          :sensor => @sensor,
          :timestamp => {'$gt' => params[:timestamp]}
      )
    elsif not params[:window].blank?
      hours = params[:window].to_i + 1
      time_late =  Time.now.getutc.to_i - (hours*60*60)
      @reads = Read.where(
          :zone => @zone,
          :sensor => @sensor,
          :timestamp => {'$gt' => time_late}
      )
    else
      @reads = Read.where(
          :zone => @zone,
          :sensor => @sensor
      )
    end

    json_response( @reads )
  end

  # POST /reads
  def create
    local_read_params = read_params
    @read = Read.create!(
        zone: @zone,
        sensor: @sensor,
        value: local_read_params[:value],
        timestamp: local_read_params[:timestamp]
    )

    generate_notification if @read.value > @sensor.max || @read.value < @sensor.min
    json_response( @read )
  end

  private

  def set_zone
    @zone = Zone.find(params[:zone])
  end

  def set_sensor
    @sensor = @zone.sensors.find(params[:sensor])
  end

  def read_params
    params.permit(:zone, :sensor, :value, :timestamp )
  end

  def generate_notification
    if @read.value > @sensor.max
      message = 'Os valores de ruido estão a acima do valor estipulado'
    elsif @read.value < @sensor.min
      message = 'Os valores de ruido estão a baixo do valor estipulado'
    end

    Notification.create(
        zone: @zone,
        sensor: @sensor,
        value: @read.value,
        min: @sensor.min,
        max: @sensor.max,
        timestamp: Time.now.getutc.to_i,
        description: message
    )
  end

  def check_params
    raise(ExceptionHandler::MissingParams, Message.missing_params ) unless ( params[:zone] and params[:sensor] )
  end

  def is_admin

    puts @current_user
    if not admin?
      raise(ExceptionHandler::AdminAuthenticationError, Message.not_admin )
    end
  end
  
end
