class ApplicationController < ActionController::Base
  include Pundit
  before_action :authenticate_user!
  before_action :set_notifications
  # before_action :set_time_zone, if: :user_signed_in?

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  def user_not_authorized
    flash[:alert] = "You are not authorized to perform this action."
    redirect_to(request.referer || root_path)
  end

  def set_notifications
    return unless user_signed_in?

    @notifications = current_user.notifications.order(created_at: :desc).limit(10)
  end

  # def set_time_zone
  #   Time.zone = current_user.time_zone
  # end
end
