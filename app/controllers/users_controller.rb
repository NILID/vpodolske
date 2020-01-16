include Pagy::Backend

class UsersController < ApplicationController
  load_and_authorize_resource find_by: :slug

  def index
    @users = (current_user&.role? :admin) ? @users.order(id: :desc) : @users.where.not(confirmed_at: nil)
    @q = @users.ransack(params[:q])
    @users = @q.result(distinct: true).includes(:profile)
  end

  def show
    @profile = @user.profile
    @events  = @user.events.order('created_at desc').limit(3)
    @organizations = @user.organizations.order(:title)
  end

  def edit
    @profile = @user.profile
  end

  def update
    @profile = @user.profile
    if @user.update(user_params)
      # ProfileMailer.settings(@profile.user).deliver
      # if params[:user][:profile_attributes] && params[:user][:profile_attributes][:avatar].present?
      #    render action: 'crop'
      # else
        redirect_to @user, notice: t('flash.update') + t('flash.profile')
      # end
    else
      render action: 'edit'
    end
  end

  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def user_params
      list_params_allowed = [
                              :login,
                              { profile_attributes: [
                                :id,
                                :aboutme,
                                :gender,
                                :avatar,
                                :avatar_params,
                                :avatar_original_w,
                                :avatar_original_h,
                                :avatar_crop_x,
                                :avatar_crop_y,
                                :avatar_crop_w,
                                :avatar_crop_h,
                                :avatar_box_w,
                                :avatar_aspect,
                                :expert_status
                              ] }
                            ]
      list_params_allowed << [roles: []] if current_user.role? :admin
      params.require(:user).permit(list_params_allowed)
    end

end
