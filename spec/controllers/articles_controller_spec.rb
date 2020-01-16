require 'rails_helper'

describe ArticlesController do
  let!(:article) { create(:article) }

  describe 'admin activities should' do
    login_user(:admin)

    it 'get manager' do
      expect(@ability.can? :manager, Article).to be true
      expect(get :manager).to render_template(:manager)
      expect(assigns(:articles)).not_to be_empty
    end

    it 'edit' do
      expect(@ability.can? :edit, article).to be true
      expect(get :edit, params: { id: article }).to render_template(:edit)
    end

    it 'parse' do
      expect(@ability.can? :parse, Article).to be true
      expect(get :parse).to redirect_to(articles_url)
    end

    it 'update' do
      expect(@ability.can? :update, article).to be true
      put :update, params: { id: article, article: attributes_for(:article) }
      expect(response).to redirect_to(articles_url(anchor: "article_#{assigns(:article).id}"))
    end

    it 'destroy' do
      expect(@ability.can? :destroy, article).to be true
      expect{ delete :destroy, params: { id: article } }.to change(Article, :count).by(-1)
      expect(response).to redirect_to(articles_path)
    end
  end

  %i[admin moderator user].each do |role|
    describe "user with #{role} role activities should" do
      login_user(role)

      it 'index' do
        expect(@ability.can? :index, Article).to be true
        expect(get :index).to render_template(:index)
        expect(assigns(:articles)).not_to be_empty
      end
    end
  end

  [:moderator, :user].each do |role|
    describe "user with #{role} role activities should" do
      login_user(role)

      it 'manager' do
        expect(@ability.cannot? :manager, Article).to be true
        expect{ get :manager }.to raise_error(CanCan:: AccessDenied)
      end

      it 'edit' do
        expect(@ability.can? :edit, article).to be false
        expect{ get :edit, params: { id: article } }.to raise_error(CanCan:: AccessDenied)
      end

      it 'update' do
        expect(@ability.can? :update, article).to be false
        expect{ put :update, params: { id: article, article: attributes_for(:article) } }.to raise_error(CanCan:: AccessDenied)
      end

      it 'not destroy' do
        expect(@ability.cannot? :destroy, article).to be true
        expect{ delete :destroy, params: { id: article } }.to raise_error(CanCan:: AccessDenied)
        expect{ response }.to change(Article, :count).by(0)
      end
    end
  end

  describe 'unreg user activities should' do
    it('index')  { expect(get :index).to render_template(:index) }

    describe 'not' do
      after(:each)      { expect(response).to redirect_to(new_user_session_path) }
      it('get new')     { get :new }
      it('get manager') { get :manager }
      it('create')      { expect{ post :create, params: { article: attributes_for(:article) } }.to change(Article, :count).by(0) }
      it('get edit')    { get :edit, params: { id: article } }
      it('update')      { put :update, params: { id: article, article: attributes_for(:article) } }
      it('destroy')     { expect{ delete :destroy, params: { id: article } }.to change(Article, :count).by(0) }
    end
  end
end
