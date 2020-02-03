class BlocksController < ApplicationController
  load_and_authorize_resource :page, find_by: :slug
  load_and_authorize_resource :block, through: :page

  def index
  end

  def show
  end

  def new
  end

  def edit
  end

  def create
    respond_to do |format|
      if @block.save
        format.html { redirect_to @page, notice: 'Block was successfully created.' }
        format.json { render :show, status: :created, location: @block }
      else
        format.html { render :new }
        format.json { render json: @block.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @block.update(block_params)
        format.html { redirect_to @page, notice: 'Block was successfully updated.' }
        format.json { render :show, status: :ok, location: @block }
      else
        format.html { render :edit }
        format.json { render json: @block.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @block.destroy
    respond_to do |format|
      format.html { redirect_to @page, notice: 'Block was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def block_params
      params.require(:block).permit(:content, :type, :position, :page_id)
    end
end
