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

  def file_hash(file)
    Digest::MD5.hexdigest(file.read)  # Using MD5, you can use other hash functions like SHA1, SHA256
  end

  # Method to check if image exists in Cloudinary by hash
  def find_existing_image(file)
    hash = file_hash(file)

    # Call Cloudinary's API to check if the image with this hash already exists
    begin
      response = Cloudinary::Api.resources(context: { file_hash: hash })
      existing_image = response["resources"].first

      if existing_image
        # Image exists, return the public_id of the existing image
        return existing_image['public_id']
      end
    rescue Cloudinary::Api::GeneralError => e
      # Handle any errors if needed (like connection issues, etc.)
      puts "Error fetching resources: #{e.message}"
    end

    # If no existing image is found, return nil
    nil
  end

  def upload_portrait(image)
    existing_public_id = find_existing_image(image)

    if existing_public_id
      # If the image exists, reuse it
      return existing_public_id
    else
      # Otherwise, upload the new image
      upload = Cloudinary::Uploader.upload(image, public_id: "character_portrait_#{SecureRandom.hex(10)}")
      return upload['public_id']
    end
  end
end
