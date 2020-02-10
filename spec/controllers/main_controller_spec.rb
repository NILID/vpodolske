require 'rails_helper'

describe MainController do
  it 'should index' do
    get :index
    expect(response).to render_template(:index)
  end
end
