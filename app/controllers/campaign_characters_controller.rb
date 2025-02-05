class CampaignCharactersController < ApplicationController
  before_action :authenticate_user!

  def create
    @campaign = Campaign.find(params[:campaign_id])
    @campaign_character = @campaign.campaign_characters.new(campaign_character_params)

    if @campaign_character.save
      flash.now[:notice] = "Invitation sent!"
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.replace("invite", partial: "campaigns/invite", locals: { campaign: @campaign, campaign_character: CampaignCharacter.new }),
            turbo_stream.update("flash", partial: "shared/flashes", locals: { notice: flash[:notice], alert: flash[:alert] })
          ]
        end
        format.html { redirect_to campaign_path(@campaign), notice: "Invitation sent!" }
      end
    else
      flash.now[:alert] = "Failed to send invite."
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.replace("invite", partial: "campaigns/invite", locals: { campaign: @campaign, campaign_character: CampaignCharacter.new }),
            turbo_stream.update("flash", partial: "shared/flashes", locals: { notice: flash[:notice], alert: flash[:alert] })
          ]
        end
        format.html { redirect_to campaign_path(@campaign), alert: "Failed to send invite." }
      end
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

  def append_personal_note
    @campaign_character = CampaignCharacter.find(params[:id])

    if params[:campaign_character][:personal_notes].present?
      new_note = "(#{Time.current.strftime('%d/%m')}): #{params[:campaign_character][:personal_notes]}"
      updated_notes = [@campaign_character.personal_notes.to_s, new_note].reject(&:blank?).join("\n")

      if @campaign_character.update(personal_notes: updated_notes)
        respond_to do |format|
          format.turbo_stream { render partial: "campaign_characters/append_personal_note", locals: { campaign_character: @campaign_character } }
          format.html { redirect_to campaign_path(@campaign), notice: "Personal note added!" }
        end
      else
        respond_to do |format|
          format.html { redirect_to campaign_path(@campaign), alert: "Error adding personal note." }
        end
      end
    else
      respond_to do |format|
        format.html { redirect_to campaign_path(@campaign_character.campaign), alert: 'Failed to add personal note.' }
      end
    end
  end


  private

  def campaign_character_params
    params.require(:campaign_character).permit(:user_id, :campaign_id, :personal_notes)

  end
end
