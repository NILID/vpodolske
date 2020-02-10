class OrganizationsController < ApplicationController
  load_and_authorize_resource

  def index
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
        org_keywords.empty? ? 0 : -1 * (org_keywords.length * 10 - org_keywords.last) # Search result score. -1 to DESC order.
      }
    end

    @q = @organizations.ransack(casetitle_cont_any: keywords)
    @q.sorts = 'title' if @q.sorts.empty?
    organizations = @q.result.distinct

    @c = Category.ransack(casetitle_cont_any: keywords)
    @c.sorts = 'title' if @c.sorts.empty?
    categories = @c.result.distinct

    unless params[:q].nil?
      @organizations = organizations.sort_by(&score)
      @categories = categories.sort_by(&score)
    end
  end

  def emails
    @organizations = @organizations.where.not(email: nil).where.not(email: '').includes(:categories)
  end

  def hidden
    @organizations = @organizations.hidden
  end

  def blocked
    @organizations = @organizations.blocked
  end

  def accept
    if @organization.email
      send_flag = @organization.notify
      @organization.update_attributes!(status_mask: (@organization.shown? ? 1 : 2), notify: true)
      @organization.send_accept_notification unless send_flag
    else
      @organization.update_attributes!(status_mask: (@organization.shown? ? 1 : 2))
    end
    redirect_to @organization, notice: t('flash.was_updated', model_name: Organization.model_name.human, title: @organization.title )
  end

  def block
    @organization.update_attributes!(status_mask: (@organization.blocked? ? 1 : 4))
    redirect_to @organization, notice: t('flash.was_updated', model_name: Organization.model_name.human, title: @organization.title )
  end

  def show
    @categories = @organization.categories
    @addresses  = @organization.addresses
    @other_organizations = (Organization.shown.joins(:categories).where(categories: { id:  @categories.pluck(:id) }).distinct - [@organization]).sample(9).sort
    @comments = @organization.comments.shown.order(created_at: :desc).includes(:user)
    @organization.update_views!
  end

  def new
    @organization.categories = Category.where(id: params[:category])
  end

  def edit;  end

  def create
    @organization.user = current_user if user_signed_in?

    respond_to do |format|
      if (user_signed_in? || verify_recaptcha(model: @organization)) && @organization.save
        if user_signed_in?
            format.html { redirect_to @organization, notice: t('flash.was_created_mod', model_name: Organization.model_name.human, title: @organization.title ) }
        else
          format.html { redirect_to categories_url, notice: t('flash.was_created_mod', model_name: Organization.model_name.human, title: @organization.title ) }
        end
        format.json { render :show, status: :created, location: @organization }
      else
        format.html { render :new }
        format.json { render json: @organization.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @organization.update(organization_params)
        format.html { redirect_to @organization, notice: t('flash.was_updated', model_name: Organization.model_name.human, title: @organization.title ) }
        format.json { render :show, status: :ok, location: @organization }
      else
        format.html { render :edit }
        format.json { render json: @organization.errors, status: :unprocessable_entity }
      end
    end
  end

  def update_access
    respond_to do |format|
      if @organization.update(organization_params)
        format.html { redirect_to @organization, notice: t('flash.was_updated', model_name: Organization.model_name.human, title: @organization.title ) }
        format.json { render :show, status: :ok, location: @organization }
      else
        format.html { render :edit }
        format.json { render json: @organization.errors, status: :unprocessable_entity }
      end
    end
  end


  def destroy
    categories = @organization.categories
    @organization.destroy
    respond_to do |format|
      categories.each { |c| c.refresh_organizations_count }
      format.html { redirect_to categories_url, notice: t('flash.was_deleted', model_name: Organization.model_name.human, title: @organization.title ) }
      format.json { head :no_content }
    end
  end

  private
    def organization_params
      address_params = (current_user&.role? :admin) ? %i[id latitude longitude address phone worktime _destroy] : %i[id address phone worktime _destroy]
      list_params_allowed = [:title, :desc, :site, :worktime, :phone, :email, :logo, { category_tokens: [], addresses_attributes: address_params } ]
      list_params_allowed << %i[status_mask statuses user_id notify] if current_user&.role? :admin
      params.require(:organization).permit(list_params_allowed)
    end
end
