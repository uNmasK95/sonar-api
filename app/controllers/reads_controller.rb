class ReadsController < ApplicationController

  before_action :check_params, :set_zone, :set_sensor

  # GET /sensors/1/reads
  def index
    # filter by last read_timestamp
    @reads = Read.all
    json_response( @reads )
  end

  # POST /sensors/1/reads
  def create
    local_read_params = read_params
    @read = Read.create!(
                    :zone => @zone,
                    :sensor => @sensor,
                    :value => local_read_params[:value],
                    :timestamp => local_read_params[:timestamp]
    )
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
    params.permit(:zone, :sensors, :value, :timestamp )
  end

  def check_params
    raise(ExceptionHandler::MissingParams, Message.missing_params ) unless ( params[:zone] && params[:sensor] )
  end

end
