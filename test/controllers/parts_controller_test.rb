require 'test_helper'

class PartsControllerTest < ActionController::TestCase
  test "should get button_css_default" do
    get :button_css_default
    assert_response :success
  end

end
