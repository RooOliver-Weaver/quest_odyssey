class NotificationsController < ApplicationController
  before_action :authenticate_user!

  def index
    @notifications = current_user.notifications.order(created_at: :desc)
    current_user.notifications.where(read: false).update_all(read: true)
  end

  def mark_as_read
    notification = current_user.notifications.find(params[:id])
    notification.update(read: true)
    head :ok
  end

  def delete_read
    current_user.notifications.where(read: true).destroy_all
    head :ok
  end
end
