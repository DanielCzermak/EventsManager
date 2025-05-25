require "test_helper"

class HomeControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:testuser_one)
    login_as(@user)
  end

  test "should get index" do
    get authenticated_root_path
    assert_response :success
  end

  def login_as(user, password: 'testpass')
    post user_session_path, params: { user: { login: user.username, password: password } }
    follow_redirect! while response.redirect?
  end
end
