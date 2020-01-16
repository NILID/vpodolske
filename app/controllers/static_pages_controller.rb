class StaticPagesController < ApplicationController
  def index; end

  def show
    render "/pages/#{params[:id]}"
  end
end
