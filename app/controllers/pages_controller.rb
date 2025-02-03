class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :home ]

  def home
  end

  def dashboard
    @user = current_user
    @campaigns = @user.campaigns
    @pending_invites = current_user.campaign_characters.where(invite: nil)
    @pending_schedule_invites = []
    @user.campaign_characters.each do |campaign_character|
      campaign_character.character_sessions do |character_session|
        @pending_schedule_invites.append(character_session) if character_session.pending
      end
    end
    @all_party_memeber_statuses =[]
    @user.campaign_characters do |campaign_character|
      campaign_character.campaigns do |campaign|
        campaign.sessions do |session|
          session.character_sessions do |character_session|
            message = "#{character_session.campaign_character.user.nickname} is currently #{character_session.status}"
            all_party_memeber_statuses.append(message)
          end
        end
      end
    end
    @joined_campaigns = current_user.campaign_characters.where(invite: true)
    @characters = Character.where(user: current_user)
  end
end
