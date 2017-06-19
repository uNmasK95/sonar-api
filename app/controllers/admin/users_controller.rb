class Admin::UsersController < ApplicationController
  before_action :is_admin
  before_action :set_user , only: [ :show, :update, :destroy ]

  # GET /users
  def index
    @users = User.all
    json_response( @users )
  end

  # GET /users/1
  def show
    json_response( @user )
  end

  # POST /users
  def create
    @user = User.create!(user_params)
    json_response( @user )
  end

  # PATCH/PUT /users/1
  def update
    if @user.update(user_params)
      json_response( @user )
    else
      json_response( @user.errors, :unprocessable_entity )
    end
  end

  # DELETE /users/1
  def destroy
    @user.destroy
    head :no_content
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def user_params
    params.permit(:email, :password, :user_type)
  end

  def is_admin
    if not admin?
      raise(ExceptionHandler::AdminAuthenticationError, Message.not_admin )
    end
  end
end
