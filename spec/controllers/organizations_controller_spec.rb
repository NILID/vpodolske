require 'rails_helper'

describe OrganizationsController do
  let!(:organization) { create(:organization) }
  let!(:organization_shown) { create(:organization, :shown) }
  let!(:category) { organization.categories.first }
  let!(:new_category) { create(:category) }
  let!(:author) { organization.user }

  describe 'admin activities should' do
    login_user(:admin)

    it 'edit' do
      expect(@ability.can? :edit, organization).to be true
      expect(get :edit, params: { id: organization }).to render_template(:edit)
    end

    it 'update' do
      expect(@ability.can? :update, organization).to be true
      expect(put :update, params: { id: organization, organization: attributes_for(:organization, category_tokens: [new_category.id]) } ).to redirect_to(assigns(:organization))
    end

    it 'accept' do
      organization.categories = [new_category]
      organization.save!
      expect(organization.status? :hidden).to be true
      expect(@ability.can? :accept, organization).to be true
      expect(put :accept, params: { id: organization }).to redirect_to(organization)
      expect(assigns(:organization).status? :hidden).to be false
    end

    it 'notify when accept' do
      organization.categories = [new_category]
      organization.save!
      expect(organization.notify).to be false
      expect(put :accept, params: { id: organization }).to redirect_to(organization)
      expect(assigns(:organization).notify).to be true
    end

    it 'not notify when accept with not email' do
      organization.categories = [new_category]
      organization.email = nil
      organization.save!
      expect(organization.notify).to be false
      expect(put :accept, params: { id: organization }).to redirect_to(organization)
      expect(assigns(:organization).notify).to be false
    end

    it 'block' do
      organization.categories = [new_category]
      organization.save!
      expect(organization.status? :hidden).to be true
      expect(@ability.can? :block, organization).to be true
      expect(put :block, params: { id: organization }).to redirect_to(organization)
      expect(assigns(:organization).status? :blocked).to be true
    end

    it 'destroy' do
      expect(@ability.can? :destroy, organization).to be true
      expect{ delete :destroy, params: { id: organization } }.to change(Organization, :count).by(-1)
      expect(response).to redirect_to(categories_path)
    end

    it 'destroy with adresses' do
      expect(organization.addresses.empty?).to be false
      addresses_count = organization.addresses.length
      expect{ delete :destroy, params: { id: organization } }.to change(Address, :count).by(-addresses_count)
    end

    it 'show hidden' do
      expect(@ability.can? :show, organization).to be true
      expect(get :show, params: { id: organization }).to render_template(:show)
    end
  end

  %i[admin moderator user].each do |role|
    describe "user with #{role} role activities should" do
      login_user(role)

      it 'index' do
        expect(@ability.can? :index, Organization).to be true
        expect(get :index, params: { category_id: organization_shown.categories.first}).to render_template(:index)
        expect(assigns(:organizations)).not_to be_empty
      end

      it 'create' do
        expect(@ability.can? :create, Organization).to be true
        expect{ post :create, params: { organization: attributes_for(:organization, category_tokens: [new_category.id]) } }.to change(Organization, :count).by(1)
        expect(response).to redirect_to(assigns(:organization))
      end

      it 'show not hidden' do
        expect(@ability.can? :show, organization_shown).to be true
        expect(get :show, params: { id: organization_shown }).to render_template(:show)
      end
    end
  end

  describe "author should" do
    before(:each) do
      sign_in(author)
      @ability = Ability.new(author)
    end

    it 'show hidden' do
      expect(@ability.can? :show, organization).to be true
      expect(get :show, params: { id: organization }).to render_template(:show)
    end

    it 'edit' do
      expect(@ability.can? :edit, organization).to be true
      expect(get :edit, params: { id: organization}).to render_template(:edit)
    end

    it 'update' do
      expect(@ability.can? :update, organization).to be true
      expect(put :update, params: { id: organization, organization: attributes_for(:organization, category_tokens: [new_category.id]) }).to redirect_to(assigns(:organization))
    end
  end

  %i[moderator user].each do |role|
    describe "user with #{role} role activities should" do
      login_user(role)

      it 'not show hidden' do
        expect(@ability.cannot? :show, organization).to be true
        expect{ get :show, params: { id: organization } }.to raise_error(CanCan:: AccessDenied)
      end

      it 'not edit' do
        expect(@ability.can? :edit, organization).to be false
        expect{ get :edit, params: { id: organization } }.to raise_error(CanCan:: AccessDenied)
      end

      it 'not accept' do
        expect(organization.status? :hidden).to be true
        expect(@ability.cannot? :accept, organization).to be true
        expect{ put :accept, params: { id: organization } }.to raise_error(CanCan:: AccessDenied)
      end

      it 'not accept' do
        expect(organization.status? :hidden).to be true
        expect(@ability.cannot? :block, organization).to be true
        expect{ put :block, params: { id: organization } }.to raise_error(CanCan:: AccessDenied)
      end

      it 'not update' do
        expect(@ability.can? :update, organization).to be false
        expect{ put :update, params: { id: organization, organization: attributes_for(:organization) } }.to raise_error(CanCan:: AccessDenied)
      end

      it 'not destroy' do
        expect(@ability.cannot? :destroy, organization).to be true
        expect{ delete :destroy, params: { id: organization } }.to raise_error(CanCan:: AccessDenied)
        expect{ response }.to change(Organization, :count).by(0)
      end
    end
  end

  describe 'unreg user activities should' do
    it('index') { expect(get :index, params: { category_id: category }).to render_template(:index) }
    it('show')  { expect(get :show, params: { id: organization_shown }).to render_template(:show) }

    it 'new' do
      expect(get :new).to render_template(:new)
    end

    it 'create' do
      expect{ post :create, params: { organization: attributes_for(:organization, category_tokens: [new_category.id]) } }.to change(Organization, :count).by(1)
      expect(response).to redirect_to(categories_url)
    end

    describe 'not' do
      after(:each)  { expect(response).to redirect_to(new_user_session_path) }
      it('get edit')    { get :edit,   params: { id: organization } }
      it('show hidden') { get :show,   params: { id: organization } }
      it('update')      { put :update, params: { id: organization, organization: attributes_for(:organization) } }
      it('accept')      { put :accept, params: { id: organization } }
      it('block')       { put :block,  params: { id: organization } }
      it('destroy')     { expect{ delete :destroy, params: { id: organization } }.to change(Organization, :count).by(0) }
    end
  end
end
