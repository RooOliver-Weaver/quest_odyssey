class CampaignsController < ApplicationController
  skip_before_action :authenticate_user!

  def index
    @campaigns = Campaign.all
  end

  def show
    @campaign = Campaign.find(params[:id])
  end

  def new
    @campaign = Campaign.new
  end

  def create
    @campaign = Campaign.new(campaign_params)
    @campign.user = current_user
    if @campaign.save!
      redirect_to campaign_path(@campaign)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @campaign = Campaign.find(params[:id])
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

  private

  def campaign_params
    params.require(:campaign).permit(:name, :setting, :description, :next_session, :notes, :active, :dm_notes)
  end

end
