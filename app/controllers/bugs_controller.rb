class BugsController < ApplicationController
  load_and_authorize_resource

  def index; end
  def new;   end

  def create
    respond_to do |format|
      if @bug.save
        format.html { redirect_to root_url, notice: 'Bug was successfully created.' }
        format.json { render :show, status: :created, location: @bug }
        format.js
      else
        format.html { render :new }
        format.json { render json: @bug.errors, status: :unprocessable_entity }
        format.js
      end
    end
  end

  def destroy
    @bug.destroy
    respond_to do |format|
      format.html { redirect_to bugs_url, notice: 'Bug was successfully destroyed.' }
      format.json { head :no_content }
      format.js
    end
  end

  private
    def bug_params
      params.require(:bug).permit(:content, :url)
    end
end
