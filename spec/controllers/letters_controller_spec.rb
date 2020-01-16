require 'rails_helper'

describe LettersController do
  let!(:letter) { create(:letter) }

  describe 'admin activities should' do
    login_user(:admin)

    it 'index' do
      expect(@ability.can? :index, Letter).to be true
      expect(get :index).to render_template(:index)
      expect(assigns(:letters)).not_to be_empty
    end

    it 'show' do
      expect(@ability.can? :show, letter).to be true
      expect(get :show, params: { id: letter }).to render_template(:show)
    end

    it 'new' do
      expect(@ability.can? :new, Letter).to be true
      expect(get :new).to render_template(:new)
    end

    it 'create' do
      expect(@ability.can? :create, Letter).to be true
      expect{ post :create, params: { letter: attributes_for(:letter) } }.to change(Letter, :count).by(1)
      expect(response).to redirect_to(assigns(:letter))
    end

    it 'destroy' do
      expect(@ability.can? :destroy, letter).to be true
      expect{ delete :destroy, params: { id: letter } }.to change(Letter, :count).by(-1)
      expect(response).to redirect_to(letters_path)
    end
  end


  [:moderator, :user].each do |role|
    describe "user with #{role} role activities should not" do
      login_user(role)

      it 'index' do
        expect(@ability.cannot? :index, Letter).to be true
        expect{ get :index }.to raise_error(CanCan:: AccessDenied)
      end

      it 'show' do
        expect(@ability.cannot? :show, letter).to be true
        expect{ get :show, params: { id: letter } }.to raise_error(CanCan:: AccessDenied)
      end

      it 'new' do
        expect(@ability.cannot? :new, Letter).to be true
        expect{ get :new }.to raise_error(CanCan:: AccessDenied)
      end

      it 'create' do
        expect(@ability.cannot? :create, Letter).to be true
        expect{ post :create, params: { letter: attributes_for(:letter) } }.to raise_error(CanCan:: AccessDenied)
        expect{ response }.to change(Letter, :count).by(0)
      end

      it 'not destroy' do
        expect(@ability.cannot? :destroy, letter).to be true
        expect{ delete :destroy, params: { id: letter } }.to raise_error(CanCan:: AccessDenied)
        expect{ response }.to change(Letter, :count).by(0)
      end
    end
  end

  describe 'unreg user activities should' do
    describe 'not' do
      after(:each)   { expect(response).to redirect_to(new_user_session_path) }

      it('index')    { get :index }
      it('show')     { get :show, params: { id: letter } }
      it('get new')  { get :new }
      it('create')   { expect{ post :create, params: { letter: attributes_for(:letter) } }.to change(Letter, :count).by(0) }
      it('destroy')  { expect{ delete :destroy, params: { id: letter } }.to change(Letter, :count).by(0) }
    end
  end
end
