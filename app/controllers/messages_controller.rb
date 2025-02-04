class MessagesController < ApplicationController

  def create
    @campaign = Campaign.find(params[:campaign_id])
    @message = Message.new(message_params)
    @message.campaign = @campaign
    @message.user = current_user
    if @message.save
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.append(:messages, partial: "campaigns/message",
            target: "messages",
            locals: { message: @message, campaign: @campaign })
        end
        format.html { redirect_to campaign_path(@campaign) }
      end
    else
      render "campaign/show", status: :unprocessable_entity
    end
  end

  private

  def message_params
    params.require(:message).permit(:content)
  end
end
