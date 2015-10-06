require 'rails_helper'

RSpec.describe CodingController, :type => :controller do

  describe "GET 'item'" do
    it "returns http success" do
      get 'item'
      expect(response).to be_success
    end
  end

end
