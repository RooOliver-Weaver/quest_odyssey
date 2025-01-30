class CampaignCharactersController < ApplicationController
  before_action :authenticate_user!

  def create
    @campaign = Campaign.find(params[:campaign_id])
    @campaign_character = @campaign.campaign_characters.new(campaign_character_params)

    if @campaign_character.save
      # After saving the new campaign character, you may want to send the invite or take other actions
      redirect_to campaign_path(@campaign), notice: 'Invite sent successfully.'
    else
      render 'campaigns/show', alert: 'Failed to send invite.'
    end
  end

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

  private

  def campaign_character_params
    params.require(:campaign_character).permit(:user_id, :campaign_id)

  end
end
