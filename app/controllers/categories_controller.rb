class CategoriesController < ApplicationController
  load_and_authorize_resource find_by: :slug

  def index
    @categories = @categories.roots.order(:title)
    @q = Organization.ransack(params[:q])
    if current_user&.role? :admin
      @hidden_orgs = Organization.hidden.pluck(:id).size
    end
  end

  def show
    @organizations = @category.organizations.shown.includes(:addresses).order(:title)
    @addresses = @organizations.map { |o| o.addresses }
    @addresses.flatten!
    @q = Organization.ransack(params[:q])
  end

  def search
    keywords = params[:q].split(/[^[[:word:]]]+/)

    @c = Category.ransack(casetitle_cont_any: keywords)
    @c.sorts = 'title' if @c.sorts.empty?
    @categories = @c.result.distinct
    respond_to do |format|
      format.json { render json: @categories.map { |c| { id: c.id, title: c.title } } }
    end
  end

  def new
    @category.parent_id = params[:parent_id]
  end

  def edit
  end

  def create_list
    @page = Nokogiri::HTML(open('http://www.podolsk.ru/catalog/'))
    @page.css('.container_left .row-spaced .media').each do |link|
      root_link = link.at_css('h4 a')
      root_cat = Category.create!(title: root_link.text.squish)
      url = root_link.attr('href')
      categories_url = Nokogiri::HTML(open(url))
      categories_url.css('.container_left .media .media-heading').each do |l|
        Category.create!(title: l.text.squish, parent_id: root_cat.id, url: l.at_css('a').attr('href'))
      end
    end

    redirect_to categories_url
  end

  def create_orgs
    Organization.make_parse(@category)
    redirect_to @category
  end

  def create
    respond_to do |format|
      if @category.save
        format.html { redirect_to @category, notice: 'Category was successfully created.' }
        format.json { render json: @category, status: :created, location: @category }
      else
        format.html { render action: 'new' }
        format.json { render json: @category.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @category.update_attributes(category_params)
        format.html { redirect_to @category, notice: 'Category was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @category.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @category.destroy

    respond_to do |format|
      format.html { redirect_to categories_url }
      format.json { head :no_content }
    end
  end

  private

    def category_params
      list_params_allowed = %i[title desc parent_id]

      params.require(:category).permit(list_params_allowed)
    end
end
