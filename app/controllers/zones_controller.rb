class ZonesController < ApplicationController
  before_action :is_admin, only: [ :create, :update, :destroy ]
  before_action :set_zone , only: [ :show, :update, :destroy ]

  # GET /zones
  def index
    @zones = Zone.all
    json_response( @zones )
  end

  # GET /zones/1
  def show
    json_response( @zone )
  end

  # POST /zones
  def create
    @zone = Zone.create!(zone_params)
    json_response( @zone )
  end

  # PATCH/PUT /zones/1
  def update
    if @zone.update(zone_params)
      json_response( @zone )
    else
      json_response( @zone.errors, :unprocessable_entity )
    end
  end

  # DELETE /zones/1
  def destroy
    @zone.destroy
    head :no_content
  end

  private
  def set_zone
    @zone = Zone.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def zone_params
    params.permit(:name, :description, :type, :max, :min)
  end

  def is_admin
    if not admin?
      raise(ExceptionHandler::AdminAuthenticationError, Message.not_admin )
    end
  end

end
