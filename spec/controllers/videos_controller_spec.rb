require 'rails_helper'

describe VideosController do
  let!(:video) { create(:video) }

  describe 'admin activities should' do
    login_user(:admin)

    it 'should get new' do
      expect(@ability.can? :new, Video).to be true
      expect(get :new).to render_template(:new)
    end

    it 'create' do
      expect(@ability.can? :create, Video).to be true
      expect{ post :create, params: { video: attributes_for(:video) } }.to change(Video, :count).by(1)
      expect(response).to redirect_to(assigns(:video))
    end

    it 'edit' do
      expect(@ability.can? :edit, video).to be true
      expect(get :edit, params: { id: video } ).to render_template(:edit)
    end

    it 'update' do
      expect(@ability.can? :update, video).to be true
      put :update, params: { id: video, video: attributes_for(:video) }
      expect(response).to redirect_to(assigns(:video))
    end

    it 'destroy' do
      expect(@ability.can? :destroy, video).to be true
      expect{ delete :destroy, params: { id: video } }.to change(Video, :count).by(-1)
      expect(response).to redirect_to(videos_path)
    end
  end

  %i[admin moderator user].each do |role|
    describe "user with #{role} role activities should" do
      login_user(role)

      it 'index' do
        expect(@ability.can? :index, Video).to be true
        expect(get :index).to render_template(:index)
        expect(assigns(:videos)).not_to be_nil
      end

      it 'show' do
        expect(@ability.can? :show, video).to be true
        expect(get :show, params: { id: video }).to render_template(:show)
      end

      it 'like' do
        expect(@ability.can? :like, video).to be true
        put :like, params: { id: video }, xhr: true
        expect(@user.likes? assigns(:video)).to be true
      end

      it 'get youtube title' do
        expect(@ability.can? :youtube_title, Video).to be true
        get :youtube_title, params: { url: 'https://youtu.be/TyPfhOoCh74'}, xhr: true
        expect(response.body).to eq("{\"result\":\"Крутая самоделка из ОБЫЧНЫХ УГОЛКОВ/Сделай и себе это простое приспособление\"}")
      end
    end
  end

  %i[moderator user].each do |role|
    describe "user with #{role} role activities should" do
      login_user(role)

      it 'should not get new' do
        expect(@ability.cannot? :new, Video).to be true
        expect{ get :new }.to raise_error(CanCan:: AccessDenied)
      end

      it 'should not get create' do
        expect(@ability.can? :create, Video).to be false
        expect{ post :create, params: { video: attributes_for(:video) } }.to raise_error(CanCan:: AccessDenied)
        expect{ response }.to change(Video, :count).by(0)
      end

      it 'edit' do
        expect(@ability.cannot? :edit, video).to be true
        expect{ get :edit, params: { id: video } }.to raise_error(CanCan:: AccessDenied)
      end

      it 'update' do
        expect(@ability.cannot? :update, video).to be true
        expect{ put :update, params: { id: video, video: attributes_for(:video) } }.to raise_error(CanCan:: AccessDenied)
      end

      it 'destroy' do
        expect(@ability.cannot? :destroy, video).to be true
        expect{ delete :destroy, params: { id: video } }.to raise_error(CanCan:: AccessDenied)
        expect{ response }.to change(Video, :count).by(0)
      end
    end
  end

  describe 'unreg user activities should' do
    it('index') { expect(get :index).to render_template(:index) }
    it('new')   { get :show, params: { id: video } }

    describe 'not' do
      after(:each)   { expect(response).to redirect_to(new_user_session_path) }

      it('new')    { get :new }
      it('create') { expect{ post :create, params: { video: attributes_for(:video) } }.to change(Video, :count).by(0) }
      it('edit')   { get :edit, params: { id: video } }
      it('like')   { put :like, params: { id: video }, xhr: true }
      it('update') { post :create, params: { video: attributes_for(:video) } }
      it('destroy') { expect{ delete :destroy, params: { id: video } }.to change(Video, :count).by(0) }
    end
  end





end
