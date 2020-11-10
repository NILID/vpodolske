class CommentsController < ApplicationController
  load_and_authorize_resource only: %i[index destroy]

  load_resource :organization, except: %i[index destroy]
  load_and_authorize_resource :comment, through: %w[organization], except: %i[index destroy]

  before_action :authorize_parent, except: %i[index destroy]

  def index
    @comments = @comments.includes(:user, :commentable).order(created_at: :desc)
  end

  def edit; end

  def create
    @comment.commentable = @commentable
    @comment.user = current_user

    respond_to do |format|
      if @comment.save && (user_signed_in? || verify_recaptcha(model: @comment, message: t('actions.verification_failed')))
        format.js
      else
        format.js
      end
    end
  end

  def update
    respond_to do |format|
      if @comment.update(comment_params)
        format.html { redirect_to polymorphic_path(@commentable, anchor: "comment_#{@comment.id}"), notice: 'Comment was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @comment.destroy
    respond_to do |format|
      format.js
    end
  end

  private

    def authorize_parent
      authorize! :read, (@video || @organization)
      @commentable = @video || @organization
    end

    def comment_params
      list_params_allowed = %i[content user_id commentable_id state ancestry]
      list_params_allowed << [:hidden] if current_user&.role? :admin
      params.require(:comment).permit(list_params_allowed)
    end
end
