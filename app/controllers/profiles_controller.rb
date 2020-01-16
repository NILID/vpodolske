class ProfilesController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource :user, find_by: :slug
  load_and_authorize_resource :profile, through: :user, singleton: :true

  def edit; end

  def update
    if @profile.update_attributes(params[:profile]) && @profile.user.update_attributes(params[:user])
      # ProfileMailer.settings(@profile.user).deliver
      if params[:profile][:avatar].present?
        render action: 'crop'
      else
        redirect_to @user, notice: t('flash.update') + t('flash.profile')
      end
    else
      render action: 'edit'
    end
  end
end
