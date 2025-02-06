class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :home ]

  def home
    @public_campaigns = Campaign.where(public: true).limit(2)
  end

  def dashboard
    @user = current_user
    @campaigns = @user.campaigns
    @pending_invites = current_user.campaign_characters.where(invite: nil)

    @pending_schedule_invites = []
    @user.campaign_characters.each do |campaign_character|
      campaign_character.character_sessions.each do |character_session|
        @pending_schedule_invites.append(character_session) if character_session.pending?
      end
    end

    @dm_sessions = Session.joins(:campaign).where(campaigns: { user_id: @user.id })

    @dm_sessions_all_accepted = []
    @dm_sessions.each do |session|
      character_sessions = session.character_sessions

      if character_sessions.any? && character_sessions.all? { |cs| cs.status == "confirmed" }
        message = "All players have accepted for the session on #{session.date}. Venture forth?"
        @dm_sessions_all_accepted << [session, message]
      end
    end


    @dm_sessions_cancellations = []
    @dm_sessions.each do |session|
      canceled_characters = session.character_sessions.where(status: "cancelled").map do |character_session|
      character_session.campaign_character.user.nickname
      end
      if canceled_characters.any?
        message = "#{canceled_characters.to_sentence} cannot make the next session. Venture forth anyway?"
        @dm_sessions_cancellations << [session, message]
      end
    end

    @joined_campaigns = current_user.campaign_characters.where(invite: true)
    @characters = Character.where(user: current_user)

    # start_date = params.fetch(:start_date, Date.today).to_date
    # @sessions = Session.where(date: start_date.beginning_of_month..start_date.end_of_month)
    @sessions = Session.where(campaign_id: @campaigns.select { |campaign| campaign.user == current_user })
  end
end
