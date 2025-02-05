class CampaignsController < ApplicationController
  skip_before_action :authenticate_user!
  before_action :set_campaign, only: %i[show edit update destroy append_note append_dm_note]
  before_action :authorize_user, only: %i[edit update destroy]

  def index
    if params[:query].present?
      @campaigns = Campaign.where("name ILIKE ?", "%#{params[:query]}%")
    else
      @campaigns = Campaign.all
    end
  end


  def show
    @campaign_character = CampaignCharacter.new
    @message = Message.new
    @personal_notes_character = current_user.campaign_characters.find_by(campaign: @campaign)
  end

  def new
    @campaign = Campaign.new
  end

  def create
    @campaign = Campaign.new(campaign_params)
    @campaign.user = current_user
    if @campaign.save!
      redirect_to campaign_path(@campaign)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    @campaign = Campaign.find_by(id: params[:id])

    respond_to do |format|
      if @campaign && @campaign.update(campaign_params)
        format.html { redirect_to campaign_path(@campaign), notice: 'Campaign updated successfully.' }
        format.json { render :show, status: :ok, location: @campaign }
      else
        format.html { render :edit, alert: 'Failed to update campaign.' }
        format.json { render json: @campaign.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @campaign.destroy!
    redirect_to campaigns_path
  end

  def append_note
    if params[:campaign][:notes].present?

      new_note = "#{current_user.nickname} (#{Time.current.strftime('%d/%m')}): #{params[:campaign][:notes]}"
      updated_notes = [@campaign.notes.to_s, new_note].reject(&:blank?).join("\n")

      if @campaign.update(notes: updated_notes)
        respond_to do |format|
          format.turbo_stream { render partial: "campaigns/append_note", locals: { campaign: @campaign } }
          format.html { redirect_to campaign_path(@campaign), notice: "Note added!" }
        end
      else
        respond_to do |format|
          format.html { redirect_to campaign_path(@campaign), alert: "Failed to add note." }
        end
      end
    else
      respond_to do |format|
        format.html { redirect_to campaign_path(@campaign), alert: "Failed to add note." }
      end
    end
  end

  def append_dm_note
    if params[:campaign][:dm_notes].present?

      new_note = "(#{Time.current.strftime('%d/%m')}): #{params[:campaign][:dm_notes]}"
      updated_notes = [@campaign.dm_notes.to_s, new_note].reject(&:blank?).join("\n")

      if @campaign.update(dm_notes: updated_notes)
        respond_to do |format|
          format.turbo_stream { render partial: "campaigns/append_dm_note", locals: { campaign: @campaign } }
          format.html { redirect_to campaign_path(@campaign), notice: "DM Note added!" }
        end
      else
        respond_to do |format|
          format.html { redirect_to campaign_path(@campaign), alert: "Failed to add DM note." }
        end
      end
    else
      respond_to do |format|
        format.html { redirect_to campaign_path(@campaign), alert: 'Failed to add DM note.' }
      end
    end
  end

  private

  def set_campaign
    @campaign = Campaign.find(params[:id])
  end

  def campaign_params
    params.require(:campaign).permit(:name, :setting, :description, :next_session, :notes, :active, :dm_notes, :image)
  end

  def authorize_user
    authorize @campaign
  end

end
