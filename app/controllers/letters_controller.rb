class LettersController < ApplicationController
  load_and_authorize_resource

  def index; end
  def show;  end
  def new;   end

  def create
    respond_to do |format|
      if @letter.save
        format.html { redirect_to @letter, notice: 'Letter was successfully created.' }
        format.json { render :show, status: :created, location: @letter }
      else
        format.html { render :new }
        format.json { render json: @letter.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @letter.destroy
    respond_to do |format|
      format.html { redirect_to letters_url, notice: 'Letter was successfully destroyed.' }
      format.json { head :no_content }
      format.js
    end
  end

  private
    def letter_params
      params.require(:letter).permit(:content, :email)
    end
end
