require "test_helper"

class EventsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:testuser_one)
    login_as(@user)
  end
  
  test "should get index" do
    get events_index_url
    assert_response :success
    assert_match events(:event_one).name, response.body
  end

  test "should get new" do
    get events_new_url
    assert_response :success
  end

  test "shouldn't get edit" do
    get events_edit_url(events(:event_three))
    assert_redirected_to events_index_url
    assert_match "aren't authorized", flash[:alert]
  end

  test "should get destroy only if valid user" do
    assert_difference("Event.count", -1) do
      delete events_destroy_url(events(:event_one))
    end
    assert_redirected_to events_index_path
  end

  def login_as(user, password: 'testpass')
    post user_session_path, params: { user: { login: user.username, password: password } }
    follow_redirect! while response.redirect?
  end
end
