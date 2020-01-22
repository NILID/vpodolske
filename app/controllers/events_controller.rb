class EventsController < ApplicationController
  load_and_authorize_resource

  def index
    @plustag = t('seo.events.soon')
    if params[:by] == 'rate'
      @events = Event.where(hidden: false).where('eventdate > ?', Date.yesterday).sort_by{|event| event.votes_for.size}.reverse
      @plustag = t('sort_by.rate')
    elsif params[:by] == 'created'
      @events = Event.where(hidden: false).order(created_at: :desc)
      @plustag = t('sort_by.rate')
    elsif params[:by] == 'owner'
      @user = current_user
      @events = @user.events.order('eventdate asc')
      @plustag = t('sort_by.owner')
    elsif params[:by] == 'user'
      user = User.where(id: params[:by]).first
      @events = user.events.where(hidden: false).order('eventdate asc')
    else
      @events = Event.where('(eventdate >= ? OR (finishdate >=? OR timeless = ?)) AND hidden=? AND cool = ?', Date.today, Date.today, true, false, false)
          .order(eventdate: :asc)
    end
  end

  def archive
    @events = @events.where(hidden: false).where('eventdate < ?', Date.today).order('eventdate desc')
    @plustag = t('seo.events.archive')
    render :index
  end

  def admin
    @events_hid = @events.where(hidden: true, excluded_flag: false)
    if params[:by] == 'excluded'
      @events_hid = @events.where(excluded_flag: true)
    end
  end

  def coolme
    @event.set_cool
    respond_to :js
  end

  def calendar
    @events = @events.where(hidden: false)
    @date = params[:month] ? Date.parse(params[:month]) : Date.today
    @event = Event.new
  end

  def like
    @voteuser = current_user
    if !@voteuser.voted_for? @event
      @event.liked_by @voteuser
      @event.vote_by voter: @voteuser, vote: 'like'
      flash[:notice]='Thank you for your vote'
    else
      flash[:notice]='You has already voted'
    end
    respond_to :js
  end

  def unlike
    @voteuser=current_user
    if !@voteuser.voted_for? @event
      @event.downvote_from @voteuser
      @event.vote_by voter: @voteuser, vote: 'bad'
      flash[:notice]='Thank you for your vote'
    else
     flash[:notice]='You has already voted'
    end
    respond_to :js
  end

  def show
    @other_events = @event.user ? @event.user.events.where('hidden = ? AND id !=?', false, @event.id).order('eventdate asc').limit(5) : []
    @event.update_views!
  end

  def new
  end

  def edit
  end

  def create
    @event.user = current_user if user_signed_in?
    respond_to do |format|
      if  (user_signed_in? || verify_recaptcha(model: @event)) && @event.save
        if user_signed_in?
          format.html { redirect_to @event, notice: t('flash.create') + t('flash.event') }
        else
          format.html { redirect_to events_url, notice: t('flash.create') + t('flash.event') + t('flash.admin_check') }
        end
      else
        # format.html { redirect_to new_user_event_path(@user, @event) }
        format.html { render action: 'new' }
      end
    end
  end

  def parse
    Event.make_parse
    redirect_to events_path
  end

  def parse_druzhba
    Event.make_parse_druzhba
    redirect_to events_path
  end


  def parse_lepse
    Event.make_parse_lepse
    redirect_to events_path
  end

  def parse_karl
    Event.make_parse_karl
    redirect_to events_path
  end

  def parse_molodezh
    Event.make_parse_molodezh
    redirect_to events_path
  end

  def parse_talal
    Event.make_parse_talal
    redirect_to events_path
  end

  def parse_dubrov
    Event.make_parse_dubrov
    redirect_to events_path
  end


  def update
    respond_to do |format|
      if @event.update_attributes(event_params)
        format.html { redirect_to @event, notice:  t('flash.update') + t('flash.event') }
      else
        format.html { render action: 'edit' }
      end
    end
  end

  def destroy
    @event.destroy

    respond_to do |format|
      format.html { redirect_to events_url }
      format.js { render nothing: true}
    end
  end

  private

    def event_params
      list_params_allowed = [
        :title,
        :content,
        :url,
        :src,
        :placename,
        :eventdate,
        :eventime,
        :finishdate,
        :finishtime,
        :timeless,
        :address,
        :latitude,
        :longitude,
        :gmaps
      ]
      list_params_allowed << [:hidden, :cool, :excluded_flag] if current_user&.role? :admin
      params.require(:event).permit(list_params_allowed)
    end

end
