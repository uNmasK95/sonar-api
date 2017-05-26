class GraphicsController < ApplicationController
  before_action :set_user, :set_line
  before_action :set_graphic, only: [ :show, :update, :destroy ]

  # GET /graphics
  def index
    @graphics = @line.graphics
    json_response( @graphics )
  end

  # GET /graphics/1
  def show
    json_response( @graphic )
  end

  # POST /graphics
  def create
    @graphic = @line.graphics.create!( graphic_params )
    json_response( @graphic )
  end

  # PUT /graphics/1
  def update
    if @graphic.update(graphic_params)
      json_response( @graphic )
    else
      json_response( @graphic.errors, :unprocessable_entity )
    end  end

  # DELETE /graphics/1
  def destroy
    @graphic.destroy
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
    @graphic = @line.graphics.find(params[:id])
  end

  def graphic_params
    params.permit(:name, :rangeTime)
  end

end
