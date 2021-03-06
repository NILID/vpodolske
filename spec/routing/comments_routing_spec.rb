require "rails_helper"

RSpec.describe CommentsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/comments").to route_to("comments#index")
    end

    it "routes to #edit" do
      expect(:get => "/spravochnik/organizations/1/comments/1/edit").to route_to("comments#edit", :id => "1", organization_id: '1')
    end

    it "routes to #create" do
      expect(:post => "/spravochnik/organizations/1/comments").to route_to("comments#create", organization_id: '1')
    end

    it "routes to #update via PUT" do
      expect(:put => "/spravochnik/organizations/1/comments/1").to route_to("comments#update", :id => "1", organization_id: '1')
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/spravochnik/organizations/1/comments/1").to route_to("comments#update", :id => "1", organization_id: '1')
    end

    it "routes to #destroy" do
      expect(:delete => "/comments/1").to route_to("comments#destroy", :id => "1")
    end
  end
end
