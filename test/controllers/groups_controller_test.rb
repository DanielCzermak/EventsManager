require "test_helper"

class GroupsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:testuser_one)
    login_as(@user)
  end

  test "should get index" do
    get groups_url
    assert_response :success
  end

  test "should get new" do
    get new_group_url
    assert_response :success
  end

  test "should get edit" do
    get edit_group_url(groups(:group_two))
    assert_response :success
  end

   test "shouldn't get edit" do
    get edit_group_url(groups(:group_one))
    assert_redirected_to groups_url
  end

  test "should join group with code" do
    post join_groups_url, params: { joinCode: "12345678" }
    groups(:group_one).users.exists?(@user.id)
    assert_redirected_to groups_url
  end

  test "should not join group with invalid code" do
    post join_groups_url, params: { joinCode: "VERYWRONGCODE" }
    assert_redirected_to groups_url
    follow_redirect!
    assert_match "Invalid join code", flash[:alert]
  end

  def login_as(user, password: 'testpass')
    post user_session_path, params: { user: { login: user.username, password: password } }
    follow_redirect! while response.redirect?
  end
end
