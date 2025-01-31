class CharacterSessionsController < ApplicationController
  def update
    @character_session = CharacterSession.find(params[:id])
  end
end
