class MainController < ApplicationController
  def index
    today = Date.today
    tomorrow = today + 1.days
    after_tomorrow = today + 2.days

    @ev_today = Event.where('eventdate = ? or (eventdate < ? AND finishdate > ?)', today, today, today)
                     .where(hidden: false)
                     .sample(6)
    @ev_tomorrow = Event.where('eventdate = ? or (eventdate < ? AND finishdate > ?)', tomorrow, tomorrow, tomorrow)
                        .where(hidden: false)
                        .sample(6)
    @ev_soon = Event.where('eventdate >=? OR (timeless = ? OR finishdate >=?)', after_tomorrow, true, after_tomorrow)
                    .where(hidden: false)
                    .order(Arel.sql('random()'))
                    .limit(6)
                    .order('eventdate')
    @users = User.where.not(confirmed_at: nil).includes(:profile).order(created_at: :desc).limit(6)
    @articles = Article.order('created_at desc').limit(5)
    @comments = Comment.shown.includes(:user, :commentable).order(created_at: :desc).limit(5)
    # NEWS
    # source = 'http://inpodolsk.ru/novosti?page=1'
    # @page = Nokogiri::HTML(open(source.to_s))
  end

  def sponsor
    @page = Page.where(id: 2).first
  end

  def about
    @page = Page.where(id: 1).first
  end

  def orelireshka
    # source = 'https://friday.ru/votes/gorod/'
    # @page = Nokogiri::HTML(open(source.to_s))
  end
end
