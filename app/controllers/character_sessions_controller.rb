class CharacterSessionsController < ApplicationController

  def update
    @character_session.update(character_session_params)
    p @character_session
    if @character_session.save!
      redirect_to root_path(), notice: "The DM and your group have been notified of your ability to attend on this day"
      SessionStatusService.new(character_session.session).checkstatusplayers(@character_session)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def character_session_params
    params.require(:character_session).permit(:status )
  end
end
