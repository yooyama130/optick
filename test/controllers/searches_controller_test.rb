require 'test_helper'

class SearchesControllerTest < ActionDispatch::IntegrationTest
  test "should get top" do
    get searches_top_url
    assert_response :success
  end

  test "should get result" do
    get searches_result_url
    assert_response :success
  end

end
