class CharacterSessionsController < ApplicationController

  def update
    @character_session = CharacterSession.find(params[:id])
    @character_session.update({status: params[:status]})
    p @character_session
    if @character_session.save!
      SessionStatusService.new(@character_session.session).checkstatusplayers
      redirect_to root_path(), notice: "The DM and your group have been notified of your ability to attend on this day"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def character_session_params
    hello = params.require(:character_session).permit(:id, :status)
    p "HELLO #{hello}"
  end
end
