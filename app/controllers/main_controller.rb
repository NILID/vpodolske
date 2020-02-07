class MainController < ApplicationController
  def index
    today = Date.today

    @ev_today = Event.where('eventdate = ? or (eventdate < ? AND finishdate > ?)', today, today, today)
                     .where(hidden: false)
                     .sample(6)
    @articles = Article.order('created_at desc').limit(4)
    @comments = Comment.shown.includes(:user, :commentable).order(created_at: :desc).limit(5)
  end

  def sponsor; end
  def about;   end
end
