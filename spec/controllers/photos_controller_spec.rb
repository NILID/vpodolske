require 'rails_helper'

describe PhotosController do
  let!(:user)  { create(:user) }
  let!(:place) { create(:place) }
  let!(:photo) { create(:photo, place: place) }

  describe 'admin activities should' do
    login_user(:admin)

    it 'create' do
      expect(@ability.can? :create, Photo).to be true
      expect{ post :create, params: { place_id: place, photo: attributes_for(:photo) } }.to change(Photo, :count).by(1)
      post :create, params: { place_id: place, photo: attributes_for(:photo) }
      expect(response).to redirect_to(assigns(:photo).place)
    end

    it 'edit' do
      expect(@ability.can? :edit, photo).to be true
      expect(get :edit, params: { place_id: place, id: photo }).to render_template(:edit)
    end

    it 'update' do
      expect(@ability.can? :update, photo).to be true
      expect(put :update, params: { place_id: place, id: photo, photo: attributes_for(:photo)}).to redirect_to(assigns(:photo).place)
    end

    it 'destroy' do
      expect(@ability.can? :destroy, photo).to be true
      expect{ delete :destroy, params: { place_id: place, id: photo} }.to change(Photo, :count).by(-1)
      expect(response).to redirect_to(assigns(:photo).place)
    end
  end

  %i[admin moderator user].each do |role|
    describe "user with #{role} role activities should" do
      login_user(role)

      it 'index' do
        expect(@ability.can? :index, Photo).to be true
        expect(get :index, params: { place_id: place }).to render_template(:index)
        expect(assigns(:photos)).not_to be_empty
      end

      it 'new' do
        expect(@ability.can? :new, Photo).to be true
        expect(get :new, params: { place_id: place }).to render_template(:new)
      end
    end
  end

  [:moderator, :user].each do |role|
    describe "user with #{role} role activities should" do
      login_user(role)

      it 'create' do
        expect(@ability.can? :create, Photo).to be true
        expect{ post :create, params: { place_id: place, photo: attributes_for(:photo) } }.to change(Photo, :count).by(1)
        expect(response).to redirect_to(assigns(:photo).place)
        expect{ response }.to change { ActionMailer::Base.deliveries.count }.by(User.admins.size)
      end

      it 'not destroy' do
        expect(@ability.cannot? :destroy, photo).to be true
        expect{ delete :destroy, params: { place_id: place, id: photo } }.to raise_error(CanCan:: AccessDenied)
        expect{ response }.to change(Photo, :count).by(0)
      end

      it 'not edit not own' do
        expect(@ability.cannot? :edit, photo).to be true
        expect{ get :edit, params: { place_id: place, id: photo } }.to raise_error(CanCan:: AccessDenied)
      end

      it 'not update not own' do
        expect(@ability.cannot? :update, photo).to be true
        expect{ put :update, params: { place_id: place, id: photo, photo: attributes_for(:photo) } }.to raise_error(CanCan:: AccessDenied)
      end
    end
  end

  describe 'unreg user activities should' do
    it('index')  { expect(get :index, params: { place_id: place }).to render_template(:index) }
    it('new')    { expect(get :new, params: { place_id: place }).to render_template(:new) }

    it('create') do
      expect{ post :create, params: { place_id: place, photo: attributes_for(:photo) } }.to change(Photo, :count).by(1)
      expect(response).to redirect_to(assigns(:photo).place)
    end

    describe 'not' do
      after(:each)  { expect(response).to redirect_to(new_user_session_path) }
      it('get edit')   { get :edit, params: { place_id: place, id: photo } }
      it('update')     { put :update, params: { place_id: place, id: photo, photo: attributes_for(:photo) } }
      it('destroy')    { expect{ delete :destroy, params: { place_id: place, id: photo } }.to change(Photo, :count).by(0) }
    end
  end
end
