class PhotosController < ApplicationController
  load_and_authorize_resource :place
  load_and_authorize_resource :photo, through: :place

  def index
  end

  def new
  end

  def edit
  end

  def create
    if user_signed_in?
      @photo.user = current_user
    end
    respond_to do |format|
      if @photo.save && (user_signed_in? || verify_recaptcha(model: @photo, message: t('actions.verification_failed')))
        format.html { redirect_to @place, notice: 'Photo was successfully created.' }
        format.json { render :show, status: :created, location: @photo }
      else
        format.html { render :new }
        format.json { render json: @photo.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @photo.update(photo_params)
        format.html { redirect_to @place, notice: 'Photo was successfully updated.' }
        format.json { render :show, status: :ok, location: @photo }
      else
        format.html { render :edit }
        format.json { render json: @photo.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @photo.destroy
    respond_to do |format|
      format.html { redirect_to @place, notice: 'Photo was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def photo_params
      params.require(:photo).permit(:content, :slide, :place_id, :user_id, :year, :author)
    end
end
