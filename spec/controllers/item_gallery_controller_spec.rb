require 'rails_helper'

RSpec.describe ItemGalleryController, :type => :controller do

  describe "GET 'index'" do
    it "returns http success" do
      get 'index'
      expect(response).to be_success
    end
  end

  describe "GET 'preview'" do
    it "returns http success" do
      get 'preview'
      expect(response).to be_success
    end
  end

  describe "GET 'add'" do
    it "returns http success" do
      get 'add'
      expect(response).to be_success
    end
  end

end
