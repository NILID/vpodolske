include Pagy::Backend

class ArticlesController < ApplicationController
  before_action :authenticate_user!, except: %i[index manager show]
  load_and_authorize_resource

  def index
    articles_list
  end

  def manager
    articles_list
  end

  def parse
    Article.mass_parse
    redirect_to articles_path
  end

  def new;  end
  def edit; end

  def create
    respond_to do |format|
      if @article.save
        format.html { redirect_to articles_path(anchor: "article_#{@article.id}"), notice: 'Article was successfully created.' }
        format.json { render json: @article, status: :created, location: @article }
      else
        format.html { render action: 'new' }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @article.update(article_params)
        format.html { redirect_to articles_path(anchor: "article_#{@article.id}"), notice: 'Article was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  def back_item
    @article = @article.versions[params[:v].to_i].reify
    @article.save
    redirect_to @article
  end

  def destroy
    @article.destroy

    respond_to do |format|
      format.html { redirect_to articles_url }
      format.json { head :no_content }
    end
  end

  private

    def articles_list

      if params[:q].nil?
        keywords = params[:q]
      else
        keywords = params[:q][:casetitle_cont_any].split(/[^[[:word:]]]+/)

        score = lambda { |org|
          org_keywords = []
          keywords
            .map { |keyword| Regexp.new(Regexp.escape(keyword), 'i') }
            .each_with_index do |keyword, index|
              org_keywords.push index if (org.title && org.title.match(keyword))
            end
          org_keywords.empty? ? 0 : -1 * (org_keywords.length * 10 - org_keywords.last)
        }
      end

      @q = @articles.ransack(casetitle_cont_any: keywords)
      @q.sorts = 'created_at desc' if @q.sorts.empty?

      @pagy, @articles = pagy(@q.result, items: 30)
    end


    def article_params
      params.require(:article).permit(:desc, :title, :url, :from_at, :provider)
    end
end
