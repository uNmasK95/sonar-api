class MetricsController < ApplicationController
  before_action :set_user, :set_line, :set_graphic
  before_action :set_metric, only: [ :show, :update, :destroy ]

  # GET /metrics
  def index
    @metrics = @graphic.metrics
    json_response( @metrics )
  end

  # GET /metrics/1
  def show
    json_response( @metric )
  end

  # POST /metrics
  def create
    @metric = @graphic.metrics.create!( metric_params )
    json_response( @metric )
  end

  # PUT /metrics/1
  def update
    if @metric.update(metric_params)
      json_response( @metric )
    else
      json_response( @metric.errors, :unprocessable_entity )
    end  end

  # DELETE /metrics/1
  def destroy
    @metric.destroy
    head :no_content
  end

  private

  def set_user
    if params[:user].blank?
      raise(ExceptionHandler::NeedUserParam, Message.need_user_params)
    else
      @user = User.find(params[:user])
    end
  end

  def set_line
    @line = @user.lines.find(params[:line_id])
  end

  def set_graphic
    @graphic = @line.graphics.find(params[:graphic_id])
  end

  def set_metric
    @graphic = @graphic.metrics.find(params[:id])
  end

  def metric_params
    params.permit(:name, :zone, :sensor)
  end
end
