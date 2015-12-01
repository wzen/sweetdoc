require 'rails_helper'

RSpec.describe MyPageController, :type => :controller do

  describe "GET 'index'" do
    it "returns http success" do
      get 'index'
      expect(response).to be_success
    end
  end

  describe "GET 'created_contents'" do
    it "returns http success" do
      get 'created_contents'
      expect(response).to be_success
    end
  end

  describe "GET 'created_item'" do
    it "returns http success" do
      get 'created_item'
      expect(response).to be_success
    end
  end

  describe "GET 'bookmark'" do
    it "returns http success" do
      get 'bookmark'
      expect(response).to be_success
    end
  end

  describe "GET 'using_item'" do
    it "returns http success" do
      get 'using_item'
      expect(response).to be_success
    end
  end

end
