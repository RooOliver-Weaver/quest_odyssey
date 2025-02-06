class CalendarsController < ApplicationController
  def index
    @user = current_user
    @campaigns = @user.campaigns
    # start_date = params.fetch(:start_date, Date.today).to_date
    # @sessions = Session.where(date: start_date.beginning_of_month..start_date.end_of_month)
    @sessions = Session.where(campaign_id: @campaigns.select { |campaign| campaign.user == current_user })
                || Session.where(campaign_id: @campaigns.select { |campaign| campaign.character.user == current_user})

    # sessions.character_sessions.each do |character_session|
    #   character.character.user == current_user
    # end
  end
end
