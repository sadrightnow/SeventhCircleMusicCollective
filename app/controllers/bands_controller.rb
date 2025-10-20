class BandsController < ApplicationController
  before_action :set_band, only: [:show, :edit, :update, :destroy, :approve]
  before_action :load_genres, only: [:index, :new, :edit, :create, :update]
  before_action :authenticate_user!

  def index
    @bands = Band.all

    # Search filter
    if params[:search].present?
      @bands = @bands.where("LOWER(band_name) LIKE ?", "%#{params[:search].downcase}%")
    end

    def validate_cloudflare_turnstile
      validation = TurnstileVerifier.check(params[:"cf-turnstile-response"], request.remote_ip)
      return if validation

      # If validation fails, we set our resource since this code is executed
      # in a `prepend_before_action`
      self.resource = resource_class.new sign_up_params
      resource.validate
      set_minimum_password_length
      respond_with_navigational(resource) { render :new }
    end



    # Genre filter
    if params[:genre_ids].present? && params[:genre_ids].reject(&:blank?).any?
      @bands = @bands.joins(:genres).where(genres: { id: params[:genre_ids] }).distinct
    end

    # Local filter
    @bands = @bands.where(local: true) if params[:local] == "1"

    # Pagination
    @bands = @bands.page(params[:page]).per(10)
  end

  def show
    redirect_to bands_path, alert: "Band not found." unless @band
  end

  def new
    @band = Band.new
  end

  def edit; end

  def create
    @band = Band.new(band_params)

    # Set to pending if user is not signed in
    @band.approved = user_signed_in?

    respond_to do |format|
      if @band.save
        format.html { redirect_to @band, notice: "Band was successfully created." }
        format.json { render :show, status: :created, location: @band }
      else
        format.html { render :new }
        format.json { render json: @band.errors, status: :unprocessable_entity }
      end
    end
  end

  def approve
    # Only allow approval by authorized users
    if current_user
      if @band.update(approved: true)
        redirect_to bands_path, notice: "Band was successfully approved."
      else
        redirect_to bands_path, alert: "Failed to approve band."
      end
    else
      redirect_to bands_path, alert: "You are not authorized to approve bands."
    end
  end

  def update
    respond_to do |format|
      if @band.update(band_params)
        format.html { redirect_to @band, notice: "Band was successfully updated." }
        format.json { render :show, status: :ok, location: @band }
      else
        format.html { render :edit }
        format.json { render json: @band.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @band.destroy
    respond_to do |format|
      format.html { redirect_to bands_url, notice: "Band was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private


  def set_band
    @band = Band.find_by(id: params[:id])
    redirect_to bands_path, alert: "Band not found." unless @band
  end

  def load_genres
    @genres = Genre.all
  end

  def band_params
    params.require(:band).permit(:band_name, :local, :band_description, :band_bandcamp_link,
                                 :band_instagram_link, :band_email, :band_location,
                                 :band_ffo, :profile_picture, genre_ids: [])
  end
end

