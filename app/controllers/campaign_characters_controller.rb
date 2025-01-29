class CampaignCharactersController < ApplicationController
  before_action :authenticate_user!

  def update
    invite = current_user.campaign_characters.find(params[:id])
    character = Character.find(params[:character_id])
    invite.update(invite: true, character_id: params[:character_id], stats: character.stats, level: character.level)
    redirect_to root_path, notice: "You have joined the campaign!"
  end

  def destroy
    @campaign_character = CampaignCharacter.find(params[:id])
    @campaign_character.destroy
    redirect_to root_path, notice: "Invite declined"
  end
end
