class NotificationsController < ApplicationController

  before_action :set_notification, :set_user, only: [ :update ]

  # GET /notifications
  def index
    # filter by last notification_timestamp and user
    if not params[:timestamp].blank? and not params[:user].blank?
      @notifications = Notification.where(
          :timestamp => {'$gt' => params[:timestamp]},
          :user_ids => {'$nin' => [ @user.id ] }
      )
    elsif not params[:timestamp].blank?
      @notifications = Notification.where(
          :timestamp => {'$gt' => params[:timestamp]},
      )
    elsif
      set_user
      @notifications = Notification.where(
          :user_ids => {'$nin' => [ @user.id ] }
      )
    else
      @notifications = Notification.all
    end

    json_response( @notifications )
  end

  # PUT /notifications/1 # only add users
  def update
    @notification.push( user_ids: @user.id )
    @notification.save
    set_notification
    json_response( @notification )

  end

  private

  def set_notification
    @notification = Notification.find(params[:id])
  end

  def set_user
    @user = User.find(params[:user])
  end


  def notification_params
    params.permit(:zone, :sensor, :value, :timestamp, :description, :max, :min )
  end
end
