class CalendarsController < ApplicationController
  def index
    @user = current_user
    @campaigns = @user.campaigns
    # start_date = params.fetch(:start_date, Date.today).to_date
    # @sessions = Session.where(date: start_date.beginning_of_month..start_date.end_of_month)
    dm_sessions = Session.where(campaign_id: @campaigns.map(&:id))
    player_sessions = Session.joins(:character_sessions)
                        .where(character_sessions: { campaign_character_id: current_user.campaign_characters.select(:id) })
    @sessions = dm_sessions + player_sessions
    @sessions.uniq!
  end
end
