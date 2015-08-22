require 'rails_helper'

RSpec.describe PageValueStateController, :type => :controller do

  describe "GET 'save'" do
    it "returns http success" do
      get 'save'
      expect(response).to be_success
    end
  end

  describe "GET 'load'" do
    it "returns http success" do
      get 'load'
      expect(response).to be_success
    end
  end

end
