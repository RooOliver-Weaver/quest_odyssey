class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :home ]

  def home
  end

  def dashboard
    @user = current_user
    @pending_invites = current_user.campaign_characters.where(invite: nil)
    @joined_campaigns = current_user.campaign_characters.where(invite: true)
  end
end
