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
    if @campaign.update(campaign_params)
      format.html { redirect_to campaign_path(@campaign) }
      format.json
    else
      format.html { render "update-show", status: :unprocessable_entity }
      format.json
    end
  end

  private

  def campaign_params
    params.require(:campaign).permit(:name, :setting, :description, :next_session, :notes, :active, :dm_notes)
  end

end
