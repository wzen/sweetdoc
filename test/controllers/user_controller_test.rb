require 'test_helper'

class UserControllerTest < ActionController::TestCase
  test "should get update_thumbnail" do
    get :update_thumbnail
    assert_response :success
  end

end
