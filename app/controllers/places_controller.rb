class PlacesController < ApplicationController
  load_and_authorize_resource except: [:get_photo, :about]

  layout 'live', only: [:index]

  def index
    @new_places = @places.order(created_at: :desc).limit(4)
    @best_places = @places.order(cached_weighted_average: :desc).limit(4)
    @sirot_places = @places.order(cached_weighted_average: :desc).limit(5)
    @places_with_address = @places.includes(:photos).map{ |p| p if p.address?}.compact
  end

  def get_photo
    @before_photo = Photo.where(id: params[:before_id]).first
    @after_photo = Photo.where(id: params[:after_id]).first
  end

  def map
    @places = @places.includes(:photos).map{ |p| p if p.address?}.compact
  end

  def gallery
    @places = if params[:sort] == 'best'
                @places.order(cached_votes_up: :desc)
              elsif params[:sort] == 'bad'
                @places.order(cached_votes_down: :desc)
              elsif params[:sort] == 'oldest'
                @places.order(:created_at)
              elsif params[:sort] == 'random'
                @places.shuffle
              else
                @places.order(created_at: :desc)
              end
  end

  def about; end

  def show
    @photos = @place.photos.order(:year)
  end

  def new
    @place.photos.build
  end

  def edit; end

  def like
    @voteuser = current_user
    if !@voteuser.voted_for? @place
      @place.liked_by @voteuser
      @place.vote_by voter: @voteuser, vote: 'like'
      flash[:notice]='Thank you for your vote'
    else
      flash[:notice]='You has already voted'
    end
    respond_to :js
  end

  def unlike
    @voteuser=current_user
    if !@voteuser.voted_for? @place
      @place.downvote_from @voteuser
      @place.vote_by voter: @voteuser, vote: 'bad'
      flash[:notice]='Thank you for your vote'
    else
      flash[:notice]='You has already voted'
    end
    respond_to :js
  end

  def create
    if user_signed_in?
      @place.user = current_user
    end
    respond_to do |format|
      if @place.save && (user_signed_in? || verify_recaptcha(model: @place, message: t('actions.verification_failed')))
        @place.photos.each do |p|
          p.user = current_user
          p.save!
        end
        format.html { redirect_to @place, notice: 'Place was successfully created.' }
        format.json { render :show, status: :created, location: @place }
      else
        format.html { render :new }
        format.json { render json: @place.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @place.update(place_params)
        format.html { redirect_to @place, notice: 'Place was successfully updated.' }
        format.json { render :show, status: :ok, location: @place }
      else
        format.html { render :edit }
        format.json { render json: @place.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @place.destroy
    respond_to do |format|
      format.html { redirect_to @place, notice: 'Place was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def place_params
      params.require(:place).permit(:title, :content, :user_id, :address, :longitude, :latitude, { photos_attributes: %i[id content year author slide _destroy] })
    end
end
