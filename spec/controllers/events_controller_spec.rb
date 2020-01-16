require 'rails_helper'

describe EventsController do
  let!(:user)  { create(:user) }
  let!(:event) { create(:event, :soon, :shown, user: user) }
  let!(:hidden_event) { create(:event, :soon, user: user) }

  describe 'admin activities should' do
    login_user(:admin)

    it 'admin' do
      expect(@ability.can? :admin, Event).to be true
      expect(get :admin).to render_template(:admin)
      expect(assigns(:events_hid)).not_to be_empty
    end

    it 'create' do
      expect(@ability.can? :create, Event).to be true
      expect{ post :create, params: { event: attributes_for(:event, :soon) } }.to change(Event, :count).by(1)
      expect(response).to redirect_to(assigns(:event))
      expect{ response }.to change { ActionMailer::Base.deliveries.count }.by(0)
    end

    it 'edit' do
      expect(@ability.can? :edit, event).to be true
      expect(get :edit, params: { id: event }).to render_template(:edit)
    end

    it 'update' do
      expect(@ability.can? :update, event).to be true
      expect(put :update, params: { id: event, event: attributes_for(:event) } ).to redirect_to(assigns(:event))
    end

    it 'coolme' do
      expect(@ability.can? :coolme, event).to be true
      expect{ put :coolme, params: { id: event }, xhr: true }.to change(Event.coolest, :count).by(1)
    end

    it 'destroy' do
      expect(@ability.can? :destroy, event).to be true
      expect{ delete :destroy, params: { id: event } }.to change(Event, :count).by(-1)
      expect(response).to redirect_to(events_path)
    end

    it 'show hidden' do
      expect(@ability.can? :show, hidden_event).to be true
      expect(get :show, params: { id: hidden_event }).to render_template(:show)
    end
  end

  describe 'for author' do
    before(:each) do
      sign_in(user)
      @ability = Ability.new(user)
    end

    describe 'for author' do
      let!(:event) { create(:event, :soon, :shown, user: user) }

      it 'edit' do
        expect(@ability.can? :edit, event).to be true
        expect(get :edit, params: { id: event }).to render_template(:edit)
      end

      it 'update' do
        expect(@ability.can? :update, event).to be true
        expect(put :update, params: { id: event, event: attributes_for(:event) }).to redirect_to(assigns(:event))
      end

      it 'show hidden' do
        expect(@ability.can? :show, hidden_event).to be true
        expect(get :show, params: { id: hidden_event }).to render_template(:show)
      end
    end
  end

  %i[admin moderator user].each do |role|
    describe "user with #{role} role activities should" do
      login_user(role)

      it 'index' do
        expect(@ability.can? :index, Event).to be true
        expect(get :index).to render_template(:index)
        expect(assigns(:events)).not_to be_empty
      end

      it 'like' do
        expect(@ability.can? :like, event).to be true
        expect{ put :like, params: { id: event }, xhr: true }.to change(event.get_upvotes, :size).by(1)
      end

      it 'unlike' do
        expect(@ability.can? :like, event).to be true
        expect{ put :unlike, params: { id: event }, xhr: true }.to change(event.get_downvotes, :size).by(1)
      end

      it 'show' do
        expect(@ability.can? :show, event).to be true
        expect(get :show, params: { id: event }).to render_template(:show)
      end

      it 'new' do
        expect(@ability.can? :new, Event).to be true
        expect(get :new).to render_template(:new)
      end

    end
  end

  [:moderator, :user].each do |role|
    describe "user with #{role} role activities should" do
      login_user(role)

      it 'create' do
        expect(@ability.can? :create, Event).to be true
        expect{ post :create, params: { event: attributes_for(:event, :soon) } }.to change(Event, :count).by(1)
        expect(response).to redirect_to(assigns(:event))
         expect{ response }.to change { ActionMailer::Base.deliveries.count }.by(User.admins.size)
      end

      it 'calendar' do
        expect(@ability.cannot? :calendar, Event).to be true
        expect{ get :calendar }.to raise_error(CanCan:: AccessDenied)
      end

      it 'not admin' do
        expect(@ability.cannot? :admin, Event).to be true
        expect{ get :admin }.to raise_error(CanCan:: AccessDenied)
      end

      it 'not destroy' do
        expect(@ability.cannot? :destroy, event).to be true
        expect{ delete :destroy, params: { id: event } }.to raise_error(CanCan:: AccessDenied)
        expect{ response }.to change(Event, :count).by(0)
      end

      it 'not show hidden' do
        expect(@ability.cannot? :show, hidden_event).to be true
        expect{ get :show, params: { id: hidden_event } }.to raise_error(CanCan:: AccessDenied)
      end

      it 'not coolme' do
        expect(@ability.cannot? :coolme, event).to be true
        expect{ put :coolme, params: { id: event }, xhr: true }.to raise_error(CanCan:: AccessDenied)
        expect{ response }.to change(Event.coolest, :count).by(0)
      end

      it 'not edit not own' do
        expect(@ability.cannot? :edit, event).to be true
        expect{ get :edit, params: { id: event } }.to raise_error(CanCan:: AccessDenied)
      end

      it 'not update not own' do
        expect(@ability.cannot? :update, event).to be true
        expect{ put :update, params: { id: event, event: attributes_for(:event) } }.to raise_error(CanCan:: AccessDenied)
      end
    end
  end

  describe 'unreg user activities should' do
    it('index')  { expect(get :index).to render_template(:index) }
    it('show')   { expect(get :show, params: { id: event }).to render_template(:show) }
    it('new')    { expect(get :new).to render_template(:new) }
    it('create') do
      expect{ post :create, params: { event: attributes_for(:event, :soon) } }.to change(Event, :count).by(1)
      expect(assigns(:event).hidden).to be true
      expect(response).to redirect_to(Event)
      expect{ response }.to change { ActionMailer::Base.deliveries.count }.by(User.admins.size)
    end

    describe 'not' do
      after(:each)  { expect(response).to redirect_to(new_user_session_path) }
      it('get show hidden') { get :show, params: { id: hidden_event } }
      it('get admin')  { get :admin }
      it('get edit')   { get :edit, params: { id: event } }
      it('update')     { put :update, params: { id: event, event: attributes_for(:event) } }
      it('destroy')    { expect{ delete :destroy, params: { id: event } }.to change(Event, :count).by(0) }
      it('not coolme') { expect{ put :coolme, params: { id: event, format: :js }, xhr: true }.to change(Event.coolest,       :count).by(0) }
      it('like')       { expect{ put :like,   params: { id: event, format: :js }, xhr: true }.to change(event.get_upvotes,   :size).by(0) }
      it('unlike')     { expect{ put :unlike, params: { id: event, format: :js }, xhr: true }.to change(event.get_downvotes, :size).by(0) }
    end
  end
end
