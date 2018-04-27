require 'test_helper'

class EventsControllerTest < ActionDispatch::IntegrationTest
  test "should get past" do
    get events_past_url
    assert_response :success
  end

  test "should get upcoming" do
    get events_upcoming_url
    assert_response :success
  end

end
