class NotesController < ApplicationController
  load_and_authorize_resource

  def index
    @notes = @notes.includes(:user)
  end

  def new
  end

  def create
    if user_signed_in?
      @note.user = current_user
    end
    respond_to do |format|
      if @note.save && (user_signed_in? || verify_recaptcha(model: @note, message: t('actions.verification_failed')))
        format.html { redirect_to root_url, notice: t('note.thanks') }
        format.json { render json: root_url, status: :created, location: @note }
      else
        format.html { render action: 'new' }
        format.json { render json: @note.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @note.destroy

    respond_to do |format|
      format.html { redirect_to notes_url }
      format.json { head :no_content }
      format.js
    end
  end

  private
    def note_params
      params.require(:note).permit(:content, :user_id, :email)
    end
end
