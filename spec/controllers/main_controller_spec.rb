require 'rails_helper'

describe MainController do
  it 'should index' do
    create_list(:user, 10)

    get :index

    expect(assigns(:ev_today)).to be_empty
    expect(assigns(:users)).not_to be_empty

    expect(response).to render_template(:index)
  end
end
