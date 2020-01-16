require 'rails_helper'

describe BugsController do
  let!(:bug) { create(:bug) }

  describe 'admin activities should' do
    login_user(:admin)

    it 'index' do
      expect(@ability.can? :index, Bug).to be true
      expect(get :index).to render_template(:index)
      expect(assigns(:bugs)).not_to be_empty
    end

    it 'destroy' do
      expect(@ability.can? :destroy, bug).to be true
      expect{ delete :destroy, params: { id: bug } }.to change(Bug, :count).by(-1)
      expect(response).to redirect_to(bugs_path)
    end
  end

  [:admin, :moderator, :user].each do |role|
    describe "user with #{role} role activities should" do
      login_user(role)

      it 'new' do
        expect(@ability.can? :new, Bug).to be true
        expect(get :new).to render_template(:new)
      end

      it 'create' do
        expect(@ability.can? :create, Bug).to be true
        expect{ post :create, params: { bug: attributes_for(:bug) } }.to change(Bug, :count).by(1)
        expect(response).to redirect_to(root_path)
      end
    end
  end

  [:moderator, :user].each do |role|
    describe "user with #{role} role activities should" do
      login_user(role)

      it 'not index' do
        expect(@ability.cannot? :index, Bug).to be true
        expect{ get :index }.to raise_error(CanCan:: AccessDenied)
      end

      it 'not destroy' do
        expect(@ability.cannot? :destroy, bug).to be true
        expect{ delete :destroy, params: { id: bug } }.to raise_error(CanCan:: AccessDenied)
        expect{ response }.to change(Bug, :count).by(0)
      end
    end
  end

  describe 'unreg user activities should' do
    it('get new') { expect(get :new).to render_template(:new) }

    it 'create' do
      expect{ post :create, params: { bug: attributes_for(:bug) } }.to change(Bug, :count).by(1)
      expect(response).to redirect_to(root_path)
    end

    describe 'not' do
      after(:each) { expect(response).to redirect_to(new_user_session_path) }
      it('index')   { get :index }
      it('destroy') { expect{ delete :destroy, params: { id: bug } }.to change(Bug, :count).by(0) }
    end
  end
end
