require 'rails_helper'

describe CategoriesController do
  let!(:category) { create(:category) }

  describe 'admin activities should' do
    login_user(:admin)

    it 'new' do
      expect(@ability.can? :new, Category).to be true
      expect(get :new).to render_template(:new)
    end

    it 'create' do
      expect(@ability.can? :create, Category).to be true
      expect{ post :create, params: { category: attributes_for(:category) } }.to change(Category, :count).by(1)
      expect(response).to redirect_to(assigns(:category))
    end

    it 'create list' do
      expect(@ability.can? :create_list, Category).to be true
    end

    it 'create list' do
      expect(@ability.can? :create_orgs, Category).to be true
    end

    it 'edit' do
      expect(@ability.can? :edit, category).to be true
      expect(get :edit, params: { id: category }).to render_template(:edit)
    end

    it 'update' do
      expect(@ability.can? :update, category).to be true
      expect(put :update, params: { id: category, category: attributes_for(:category) }).to redirect_to(category)
    end

    it 'destroy' do
      expect(@ability.can? :destroy, category).to be true
      expect{ delete :destroy, params: { id: category } }.to change(Category, :count).by(-1)
      expect(response).to redirect_to(categories_path)
    end
  end

  %i[admin moderator user].each do |role|
    describe "user with #{role} role activities should" do
      login_user(role)

      it 'index' do
        expect(@ability.can? :index, Category).to be true
        expect(get :index).to render_template(:index)
        expect(assigns(:categories)).not_to be_empty
      end

      it 'show' do
        expect(@ability.can? :show, category).to be true
        expect(get :show, params: { id: category }).to render_template(:show)
      end
    end
  end

  [:moderator, :user].each do |role|
    describe "user with #{role} role activities should" do
      login_user(role)

      it 'not new' do
        expect(@ability.cannot? :new, Category).to be true
        expect{ get :new }.to raise_error(CanCan:: AccessDenied)
      end

      it 'not create list' do
        expect(@ability.cannot? :create_list, Category).to be true
      end

      it 'not create list' do
        expect(@ability.cannot? :create_list, Category).to be true
      end

      it 'not create' do
        expect(@ability.cannot? :create, Category).to be true
        expect{ post :create, params: { category: attributes_for(:category) } }.to raise_error(CanCan:: AccessDenied)
        expect{ response }.to change(Category, :count).by(0)
      end

      it 'edit' do
        expect(@ability.can? :edit, category).to be false
        expect{ get :edit, params: { id: category } }.to raise_error(CanCan:: AccessDenied)
      end

      it 'update' do
        expect(@ability.can? :update, category).to be false
        expect{ put :update, params: { id: category, category: attributes_for(:category) } }.to raise_error(CanCan:: AccessDenied)
      end

      it 'not destroy' do
        expect(@ability.cannot? :destroy, category).to be true
        expect{ delete :destroy, params: { id: category } }.to raise_error(CanCan:: AccessDenied)
        expect{ response }.to change(Category, :count).by(0)
      end
    end
  end

  describe 'unreg user activities should' do
    it('index')  { expect(get :index).to render_template(:index) }
    it 'search' do
      get :search, params: { q: category.title, :format => :json }
      expect(response.body).to eq [id: category.id, title: category.title].to_json
    end
    it('show')   { expect(get :show, params: { id: category }).to render_template(:show) }

    describe 'not' do
      after(:each)  { expect(response).to redirect_to(new_user_session_path) }
      it('get new')    { get :new }
      it('get edit')   { get :edit, params: { id: category } }
      it('update')     { put :update, params: { id: category, category: attributes_for(:category) } }
      it('destroy')    { expect{ delete :destroy, params: { id: category } }.to change(Category, :count).by(0) }

      it('create') { expect{ post :create, params: { category: attributes_for(:category) } }.to change(Category, :count).by(0) }
    end
  end
end
