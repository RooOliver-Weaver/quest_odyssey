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
    @dm_messages = Message.where(user: current_user, message_type: "dm_approval")
    p @dm_messages
    @messages = Message.where(user: current_user, message_type: "player_notification")

    @all_party_memeber_statuses = []
    @user.campaign_characters.each do |campaign_character|
      campaign_character.campaign.sessions.each do |session|
        session.character_sessions.each do |character_session|
          message = "#{character_session.campaign_character.user.nickname} is currently #{character_session.status}"
          @all_party_memeber_statuses.append(message)
        end
      end
    end
    @all_party_memeber_statuses

    @joined_campaigns = current_user.campaign_characters.where(invite: true)
    @characters = Character.where(user: current_user)

    # start_date = params.fetch(:start_date, Date.today).to_date
    # @sessions = Session.where(date: start_date.beginning_of_month..start_date.end_of_month)
    @sessions = Session.where(campaign_id: @campaigns.select { |campaign| campaign.user == current_user })
  end
end
