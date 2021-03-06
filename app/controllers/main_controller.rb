class MainController < ApplicationController
  def index
    today = Date.today

    @events = Event.where('eventdate >= ?', today)
                     .where(hidden: false)
                     .sample(5)
    @articles = Article.order('created_at desc').limit(4)

    @comments = Comment.shown.includes(:user, :commentable).order(created_at: :desc).limit(3)
    @orgs_size = Organization.shown.pluck(:id).size
  end

  def sponsor; end
  def about;   end
end
