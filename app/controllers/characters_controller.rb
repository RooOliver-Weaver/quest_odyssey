require "origami"

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

    if params[:character][:pdf]
      pdf_text = extract_character_data(params[:character][:pdf].tempfile)
      @character.assign_attributes(pdf_text)
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

  def extract_character_data(pdf_path)
    extracted_data = {}

    # Open the PDF and extract form fields
    pdf = Origami::PDF.read(pdf_path)
    form_data = pdf.acroform.fields.map { |field| [field.name, field.value] }.to_h

    # Map PDF field names to our database fields
    field_mappings = {
      "CharacterName" => :name,
      "ClassLevel" => :speciality, # Will need further processing
      "Race" => :race,
      "Background" => :background,
      "Alignment" => :alignment,
      "STR" => [:stats, "strength"],
      "DEX" => [:stats, "dexterity"],
      "CON" => [:stats, "constitution"],
      "INT" => [:stats, "intelligence"],
      "WIS" => [:stats, "wisdom"],
      "CHA" => [:stats, "charisma"],
    }

    if form_data["ClassLevel"] =~ /(\D+)\s*(\d+)/
      extracted_data[:speciality] = $1.strip
      extracted_data[:level] = $2.to_i
    end

    # Extract and transform data
    field_mappings.each do |pdf_field, db_field|
      value = form_data[pdf_field]

      next unless value.present?

      if db_field.is_a?(Array) && db_field.first == :stats
        extracted_data[:stats] ||= {}
        extracted_data[:stats][db_field[1]] = value.to_i
      else
        extracted_data[db_field] = value.strip
      end
    end

    extracted_data
  end
end
