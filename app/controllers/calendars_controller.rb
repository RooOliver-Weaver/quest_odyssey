class CalendarsController < ApplicationController
  def index
    @user = current_user
    @campaigns = @user.campaigns
    #start_date = params.fetch(:start_date, Date.today).to_date
    #@sessions = Session.where(date: start_date.beginning_of_month..start_date.end_of_month)
    all_sessions = Session.all
    @sessions = Session.where(campaign_id: @campaigns.select { |campaign| campaign.user == current_user })
    all_sessions.each do |session|
      session.character_sessions.each do  |char_session|
        @sessions.append(session) if char_session.campagin_chararacter.user ==  current_user
      end
    end



  end
end
