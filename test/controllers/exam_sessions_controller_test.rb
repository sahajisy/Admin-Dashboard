require "test_helper"

class ExamSessionsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get exam_sessions_new_url
    assert_response :success
  end

  test "should get create" do
    get exam_sessions_create_url
    assert_response :success
  end

  test "should get destroy" do
    get exam_sessions_destroy_url
    assert_response :success
  end
end
