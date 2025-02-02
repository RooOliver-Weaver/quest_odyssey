require "digest"
require "open-uri"

class CharactersController < ApplicationController
  before_action :set_character, only: %i[ show edit update destroy ]
  before_action :authenticate_user!
  before_action :authorize_user, only: %i[ edit update destroy ]

  def index
    @characters = Character.all
  end

  def show
  end

  def new
    @user = current_user
    @character = Character.new(user: @user)
  end

  def create
    @character = Character.new(character_params)
    @character.user = current_user

    if params[:character][:portrait].present?
      @character.portrait = upload_portrait(params[:character][:portrait])
    end

    if @character.save!
      redirect_to character_path(@character)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end


  def update
    @character.update(character_params)
    if @character.save!
      redirect_to character_path(@character)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @character.destroy!
  end

  private
    # Use callbacks to share common setup or constraints between actions.
  def set_character
    @character = Character.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def character_params
    params.require(:character).permit(:name, :race, :speciality, :level, :biography, :portrait, :alignment, :background,
                                      :strength, :dexterity, :constitution, :wisdom, :intelligence, :charisma)
  end

  def authorize_user
    unless current_user == @character.user
      flash[:alert] = "You are not authorized to perform this action."
      redirect_to characters_path
    end
  end
end
