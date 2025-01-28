class CharactersController < ApplicationController
  before_action :set_booking, only: %i[ show edit update destroy ]
  before_action :authenticate_user!
  before_action :authorize_user, only: %i[ edit update destroy ]

  # GET /bookings or /bookings.json
  def index
    @characters = Character.all
  end

  # GET /bookings/1 or /bookings/1.json
  def show
  end

  # GET /bookings/new
  def new
    @character = Character.new(
      check_in: params[:check_in],
      check_out: params[:check_out]
    )
  end

  # POST /bookings or /bookings.json
  def create
    @booking = Booking.new(booking_params)
    @booking.user = current_user
    @lair = Lair.find(params[:lair_id])
    @booking.lair = @lair
    if @booking.save!
      redirect_to booking_path(@booking)
    else
      render :new, status: :unprocessable_entity
    end
  end

  # GET /bookings/1/edit
  def edit
  end


  # PATCH/PUT /bookings/1 or /bookings/1.json
  def update
    @booking.update(booking_params)
    @lair = Lair.find(@booking.lair_id)
    lairs = Booking.where(lair_id: @lair.id)
    if @booking.rating
      @lair.average_rating = (lairs.sum(:rating)/lairs.count(:rating)).round
      @lair.save!
    end
    redirect_to lair_path(@booking.lair)
  end

  # DELETE /bookings/1 or /bookings/1.json
  def destroy
    @booking.destroy!
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_booking
      @booking = Booking.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def booking_params
      params.require(:booking).permit(:check_in, :check_out, :rating)
    end

    def authorize_user
      unless current_user == @booking.user
        flash[:alert] = "You are not authorized to perform this action."
        redirect_to lairs_path
      end
    end
end
