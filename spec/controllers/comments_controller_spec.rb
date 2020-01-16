require 'rails_helper'

describe CommentsController do
  let!(:comment)     { create(:comment) }
  let!(:commentable) { comment.commentable }

  describe 'admin activities should' do
    login_user(:admin)

    it 'edit' do
      expect(@ability.can? :edit, comment).to be true
      expect(get :edit, params: { organization_id: commentable.id, id: comment }).to render_template(:edit)
    end

    it 'update' do
      expect(@ability.can? :update, comment).to be true
      expect(
        put :update, params: { organization_id: commentable.id, id: comment, comment: attributes_for(:comment) }
      ).to redirect_to(organization_path(assigns(:comment).commentable, anchor: "comment_#{assigns(:comment).id}"))
    end

    it 'destroy' do
      expect(@ability.can? :destroy, comment).to be true
      expect{ delete :destroy, params: { id: comment }, xhr: true }.to change(Comment, :count).by(-1)
    end

    it 'index' do
      expect(@ability.can? :index, Comment).to be true
      expect(get :index).to render_template(:index)
      expect(assigns(:comments)).not_to be_empty
    end
  end

  %i[moderator user admin].each do |role|
    describe "user with #{role} role activities should" do
      login_user(role)

      it 'create' do
        expect(@ability.can? :create, Comment).to be true
        expect{ post :create, params: { organization_id: commentable.id, comment: attributes_for(:comment) }, xhr: true }.to change(Comment, :count).by(1)
      end
    end
  end

  %i[moderator user].each do |role|
    describe "user with #{role} role activities should" do
      login_user(role)

      it 'index' do
        expect(@ability.cannot? :index, Comment).to be true
        expect{ get :index }.to raise_error(CanCan:: AccessDenied)
      end

      it 'not destroy' do
        expect(@ability.cannot? :destroy, comment).to be true
        expect{ delete :destroy, params: { id: comment }, xhr: true }.to raise_error(CanCan:: AccessDenied)
        expect{ response }.to change(Comment, :count).by(0)
      end

      it 'not edit' do
        expect(@ability.cannot? :edit, comment).to be true
        expect{ get :edit, params: { organization_id: commentable.id, id: comment } }.to raise_error(CanCan:: AccessDenied)
      end

      it 'not update' do
        expect(@ability.cannot? :update, comment).to be true
        expect{ put :update, params: { organization_id: commentable.id, id: comment, comment: attributes_for(:comment) } }.to raise_error(CanCan:: AccessDenied)
      end
    end
  end

  describe 'unreg user activities should' do
    it('create') do
      expect{ post :create, params: { organization_id: commentable.id, comment: attributes_for(:comment) }, xhr: true }.to change(Comment, :count).by(1)
      expect(assigns(:comment).hidden).to be true
    end

    describe 'not' do
      after(:each)   { expect(response).to redirect_to(new_user_session_path) }

      it('index')    { get :index }
      it('get edit') { get :edit, params: { organization_id: commentable.id, id: comment } }
      it('update')   { put :update, params: { organization_id: commentable.id, id: comment, comment: attributes_for(:comment) } }
      it('destroy')  { expect{ delete :destroy, params: { id: comment }, xhr: true }.to change(Comment, :count).by(0) }
    end
  end
end
