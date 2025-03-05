require "test_helper"

class ExamsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get exams_index_url
    assert_response :success
  end

  test "should get create" do
    get exams_create_url
    assert_response :success
  end

  test "should get save" do
    get exams_save_url
    assert_response :success
  end
end
