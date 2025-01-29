class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :home ]

  def home
  end

  def dashboard
    @user = current_user
  end

  def update_availability(user_params)
    @user = current_user
    @user.update!
  end

  private

  def user_params
    params.require(:character).permit(:, :avalability, :speciality, :level, :stats, :biography)
  end

end
