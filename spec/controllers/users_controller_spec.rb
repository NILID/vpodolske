require 'rails_helper'

##
##  add test for crop and crop redirect
##

describe UsersController do
  let!(:user) { create(:user) }

  describe 'admin activities should' do
    login_user(:admin)

    it 'destroy' do
      expect(@ability.can? :destroy, user).to be true
      expect{ delete :destroy, params: { id: user } }.to change(User, :count).by(-1)
      expect(response).to redirect_to(users_path)
    end

    it 'edit' do
      expect(@ability.can? :edit, user).to be true
      expect(get :edit, params: { id: user }).to render_template(:edit)
    end

    it 'update' do
      expect(@ability.can? :update, user).to be true
      expect(put :update, params: { id: user, user: { profile: attributes_for(:profile) } }).to redirect_to(assigns(:user))
    end
  end

  %i[admin moderator user].each do |role|
    describe "user with #{role} role activities should" do
      login_user(role)

      it 'index' do
        expect(@ability.can? :index, User).to be true
        expect(get :index).to render_template(:index)
        expect(assigns(:users)).not_to be_empty
      end

      it 'show' do
        expect(@ability.can? :show, user).to be true
        expect(get :show, params: { user_id: user, id: user }).to render_template(:show)
      end
    end
  end

  %i[moderator user].each do |role|
    describe "user with #{role} role activities should" do
      login_user(role)

      it 'not destroy' do
        expect(@ability.cannot? :destroy, user).to be true
        expect{ delete :destroy, params: { id: user } }.to raise_error(CanCan:: AccessDenied)
        expect{ response }.to change(User, :count).by(0)
      end

      it 'cannot edit not own' do
        expect(@ability.cannot? :edit, user).to be true
        expect{get :edit, params: { id: user }}.to raise_error(CanCan:: AccessDenied)
      end

      it 'cannot update not own' do
        expect(@ability.cannot? :update, user).to be true
        expect{put :update, params: { id: user, user: { profile: attributes_for(:profile) } } }.to raise_error(CanCan:: AccessDenied)
      end

      it 'edit own' do
        expect(@ability.can? :edit, @user).to be true
        expect(get :edit, params: { id: @user }).to render_template(:edit)
      end

      it 'update own' do
        expect(@ability.can? :update, @user).to be true
        expect(put :update, params: { id: @user, user: { profile: attributes_for(:profile) } }).to redirect_to(assigns(:user))
      end
    end
  end

  describe 'unreg user activities should' do
    it('index'){ expect(get :index).to render_template(:index) }
    it('show') { expect(get :show, params: { user_id: user, id: user}).to render_template(:show) }

    describe 'not' do
      after(:each)  { expect(response).to redirect_to(new_user_session_path) }
      it('destroy') { expect{ delete :destroy, params: { id: user } }.to change(User, :count).by(0) }
      it('edit')    { get :edit, params: { id: user } }
      it('update')  { put :update, params: { id: user, user: { profile: attributes_for(:profile) } } }
    end
  end
end
