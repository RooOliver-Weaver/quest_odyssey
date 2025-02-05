class CalendarsController < ApplicationController
  def index
    @user = current_user
    @campaigns = @user.campaigns
    start_date = params.fetch(:start_date, Date.today).to_date
    @sessions = Session.where(date: start_date.beginning_of_month..start_date.end_of_month)
  end
end
