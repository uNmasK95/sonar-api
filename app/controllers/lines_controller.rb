class LinesController < ApplicationController
  before_action :set_user
  before_action :set_line, only: [ :show, :update, :destroy ]

  # GET /lines
  def index
    @lines = @user.lines
    json_response( @lines )
  end

  # GET /lines/1
  def show
    json_response( @line )
  end

  # POST /lines
  def create
    @line = @user.lines.create!( line_params )
    json_response( @line )
  end

  # PUT /lines/1
  def update
    if @line.update(user_params)
      json_response( @line )
    else
      json_response( @line.errors, :unprocessable_entity )
    end  end

  # DELETE /lines/1
  def destroy
    @line.destroy
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
    @line = @user.lines.find(params[:id])
  end

  def line_params
    params.permit(:name)
  end

end
