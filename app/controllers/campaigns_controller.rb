class CampaignsController < ApplicationController
  skip_before_action :authenticate_user!
  before_action :set_campaign, only: %i[show edit update destroy]
  before_action :authorize_user, only: %i[edit update destroy]
  include Schedule

  def index
    @campaigns = Campaign.all
  end

  def show
    @campaign_character = CampaignCharacter.new
    @message = Message.new
  end

  def new
    @campaign = Campaign.new
  end

  def create
    @campaign = Campaign.new(campaign_params)
    @campaign.user = current_user
    if @campaign.save!
      redirect_to campaigns_path
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

  private

  def set_campaign
    @campaign = Campaign.find(params[:id])
  end

  def campaign_params
    params.require(:campaign).permit(:name, :setting, :description, :next_session, :notes, :active, :dm_notes)
  end

  def authorize_user
    authorize @campaign
  end

end
