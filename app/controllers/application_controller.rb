class ApplicationController < ActionController::API
  include Response
  include ExceptionHandler

  # called before every action on controllers
  before_action :authorize_request
  attr_reader :current_user

  private

  # Check for valid request token and return user
  def authorize_request
    @current_user = (AuthorizeApiRequest.new(request.headers).call)[:user]
  end

  # Check for admin authentication
  def admin?
    @current_user.user_type == 0
  end

  # Check for simulator authentication
  def sensor?
    @current_user.user_type == 2
  end
end
