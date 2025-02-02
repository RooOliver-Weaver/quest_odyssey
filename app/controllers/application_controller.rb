class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  # before_action :set_time_zone, if: :user_signed_in?

  private

  def user_not_authorized
    flash[:alert] = "You are not authorized to perform this action."
    redirect_to(request.referer || root_path)
  end

  # def set_time_zone
  #   Time.zone = current_user.time_zone
  # end
end
