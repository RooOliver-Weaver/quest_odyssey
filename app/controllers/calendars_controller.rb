class CalendarsController < ApplicationController
  def index
    @user = current_user
    @campaigns = @user.campaigns
  end
end
