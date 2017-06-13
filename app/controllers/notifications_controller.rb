class NotificationsController < ApplicationController

  before_action :set_notification, only: [ :update ]

  # GET /notifications
  def index
    # filter by last notification_timestamp and user
    if not params[:timestamp].blank?
      @notifications = Notification.where(
          :timestamp => {'$gt' => params[:timestamp]}
      )
    else
      @notifications = Notification.all
    end
    json_response( @notifications )
  end

  # PUT /notifications/1
  def update
    if @notification
      json_response( @notification )
    else
      json_response( @notification.errors, :unprocessable_entity )
    end
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
