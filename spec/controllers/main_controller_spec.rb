require 'rails_helper'

describe MainController do
  it 'should index' do
    create_list(:user, 10)
    create_list(:event, 10, :shown, :soon)

    get :index

    expect(assigns(:ev_today)).to be_empty
    expect(assigns(:ev_tomorrow)).to be_empty
    expect(assigns(:ev_soon)).not_to be_empty
    expect(assigns(:users)).not_to be_empty

    expect(response).to render_template(:index)
  end

  it 'should index but not events if they hidden' do
    create_list(:event, 10, :soon)

    get :index

    expect(assigns(:ev_soon)).to be_empty
    expect(assigns(:ev_tomorrow)).to be_empty
    expect(assigns(:ev_soon)).to be_empty

    expect(response).to render_template(:index)
  end

end
