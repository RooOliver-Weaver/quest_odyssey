class CharacterSessionsController < ApplicationController
  include Schedule
  def update
    @character_session.update(character_session_params)
    if @character_session.save!
      checkstatusplayers(character_session.session)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def character_session_params
    params.require(:character).permit(:status)
  end
end
