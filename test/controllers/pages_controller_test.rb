require 'test_helper'

class PagesControllerTest < ActionDispatch::IntegrationTest
  test "should get about" do
    get pages_about_url
    assert_response :success
  end

  test "should get blog" do
    get pages_blog_url
    assert_response :success
  end

  test "should get chat" do
    get pages_chat_url
    assert_response :success
  end

  test "should get content" do
    get pages_content_url
    assert_response :success
  end

  test "should get frapp_talk" do
    get pages_frapp_talk_url
    assert_response :success
  end

  test "should get fusion" do
    get pages_fusion_url
    assert_response :success
  end

  test "should get profile" do
    get pages_profile_url
    assert_response :success
  end

end
