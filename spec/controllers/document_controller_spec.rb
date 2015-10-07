require 'rails_helper'

RSpec.describe DocumentController, :type => :controller do

  describe "GET 'terms'" do
    it "returns http success" do
      get 'terms'
      expect(response).to be_success
    end
  end

  describe "GET 'privacy'" do
    it "returns http success" do
      get 'privacy'
      expect(response).to be_success
    end
  end

  describe "GET 'help'" do
    it "returns http success" do
      get 'help'
      expect(response).to be_success
    end
  end

  describe "GET 'inquiry'" do
    it "returns http success" do
      get 'inquiry'
      expect(response).to be_success
    end
  end

  describe "GET 'about'" do
    it "returns http success" do
      get 'about'
      expect(response).to be_success
    end
  end

  describe "GET 'referense'" do
    it "returns http success" do
      get 'referense'
      expect(response).to be_success
    end
  end

  describe "GET 'info'" do
    it "returns http success" do
      get 'info'
      expect(response).to be_success
    end
  end

end
