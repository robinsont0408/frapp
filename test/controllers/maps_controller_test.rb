require 'test_helper'

class MapsControllerTest < ActionDispatch::IntegrationTest
  test "should get google_maps" do
    get maps_google_maps_url
    assert_response :success
  end

end
