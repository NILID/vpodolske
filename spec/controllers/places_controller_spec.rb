require 'rails_helper'

describe PlacesController do
  let!(:place) { create(:place) }

  describe 'admin activities should' do
    login_user(:admin)

    it 'destroy' do
      expect(@ability.can? :destroy, place).to be true
      expect{ delete :destroy, params: { id: place } }.to change(Place, :count).by(-1)
      expect(response).to redirect_to(places_path)
    end
  end

  [:admin, :moderator, :user].each do |role|
    describe "user with #{role} role activities should" do
      login_user(role)

      it 'index' do
        expect(@ability.can? :index, Place).to be true
        expect(get :index).to render_template(:index)
        expect(assigns(:places)).not_to be_empty
      end

      it 'index' do
        expect(@ability.can? :map, Place).to be true
        expect(get :map).to render_template(:map)
        expect(assigns(:places)).not_to be_empty
      end

      it 'gallery' do
        expect(@ability.can? :gallery, Place).to be true
        expect(get :gallery).to render_template(:gallery)
        expect(assigns(:places)).not_to be_empty
      end

      it 'about' do
        expect(@ability.can? :about, Place).to be true
        expect(get :about).to render_template(:about)
      end

      it 'like' do
        expect(@ability.can? :like, place).to be true
        expect{ put :like, params: { id: place }, xhr: true }.to change(place.get_upvotes, :size).by(1)
      end

      it 'unlike' do
        expect(@ability.can? :like, place).to be true
        expect{ put :unlike, params: { id: place }, xhr: true }.to change(place.get_downvotes, :size).by(1)
      end

      it 'new' do
        expect(@ability.can? :new, Place).to be true
        expect(get :new).to render_template(:new)
      end

      it 'create' do
        expect(@ability.can? :create, Place).to be true
        expect{ post :create, params: { place: attributes_for(:place) } }.to change(Place, :count).by(1)
        expect(response).to redirect_to(assigns(:place))
      end
    end
  end

  [:moderator, :user].each do |role|
    describe "user with #{role} role activities should" do
      login_user(role)

      it 'not destroy' do
        expect(@ability.cannot? :destroy, place).to be true
        expect{ delete :destroy, params: { id: place } }.to raise_error(CanCan:: AccessDenied)
        expect{ response }.to change(Place, :count).by(0)
      end
    end
  end

  describe 'unreg user activities should' do
    it('index')   { expect(get :index).to render_template(:index) }
    it('gallery') { expect(get :gallery).to render_template(:gallery) }
    it('map')     { expect(get :map).to render_template(:map) }
    it('about')   { expect(get :about).to render_template(:about) }
    it('new')     { expect(get :new).to render_template(:new) }

    it 'create' do
      expect{ post :create, params: { place: attributes_for(:place) } }.to change(Place, :count).by(1)
      expect(response).to redirect_to(assigns(:place))
    end

    describe 'not' do
      after(:each) { expect(response).to redirect_to(new_user_session_path) }
      it('destroy') { expect{ delete :destroy, params: { id: place } }.to change(Place, :count).by(0) }

      it 'like' do
        expect{ put :like, params: { id: place }, xhr: true }.to change(place.get_upvotes, :size).by(0)
      end

      it 'unlike' do
        expect{ put :unlike, params: { id: place }, xhr: true }.to change(place.get_downvotes, :size).by(0)
      end
    end
  end
end
