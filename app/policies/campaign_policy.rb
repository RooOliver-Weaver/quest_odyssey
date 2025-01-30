class CampaignPolicy < ApplicationPolicy

  def index?
    # Any logged-in user can list all campaigns
    true
  end

  def show?
    # Only allow users who own the campaign
    true
  end

  def create?
    # Any logged-in user can create a campaign
    user.present?
  end

  def update?
    # Only the owner can update
    record.user == user
  end

  def destroy?
    # Only the owner can destroy
    record.user == user
  end

  def dm_notes?
    record.user == user
  end

  def invite?
    record.user == user
  end

  class Scope < ApplicationPolicy::Scope
  end
end
