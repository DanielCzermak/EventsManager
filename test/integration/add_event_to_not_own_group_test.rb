require "test_helper"

class AddEventToNotOwnGroupTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:testuser_one)
    @group = groups(:group_one)
  end

  test "add event to not own group" do
    get new_user_session_path
    assert_response :success
    assert_select "form#new_user"

    post user_session_path, params: {
      user: {
        login: @user.username,
        password: "testpass"
      }
    }
    follow_redirect! while response.redirect?
    assert_response :success
    assert_match "Welcome", response.body

    get events_index_path
    assert_response :success
    assert_match "Monthly Meeting", response.body

    get events_new_path
    assert_response :success

    assert_difference("Event.count", 1) do
      post events_create_path, params: {
        event: {
          name: "Integration Event",
          description: "Integration test",
          start_date: "2025-06-01 10:00:00",
          end_date: "2025-06-01 12:00:00",
          location: "Test location",
          group_id: @group.id,
          frequency: :once
        }
      }
    end
    assert_redirected_to events_index_path
    follow_redirect!
    assert_match "Integration Event", response.body

    delete destroy_user_session_path
    follow_redirect! while response.redirect?

    assert_select "form#new_user"
  end
end
