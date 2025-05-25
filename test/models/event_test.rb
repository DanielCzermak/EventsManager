require "test_helper"

class EventTest < ActiveSupport::TestCase
  def setup
    @one_off_event = events(:event_two)
    @monthly_event = events(:event_one)
    @weekly_event = events(:event_three)
  end

  test "are fixture events valid" do
    assert @one_off_event.valid?
    assert @monthly_event.valid?
    assert @weekly_event.valid?
  end

  test "name is required" do
    @weekly_event.name = nil
    assert_not @weekly_event.valid?
  end

  test "name is valid length" do
    @weekly_event.name = "ab"
    assert_not @weekly_event.valid?
    @weekly_event.name = "a" * 65
    assert_not @weekly_event.valid?
  end

  test "description is optional and valid length" do
    @weekly_event.description = nil
    assert @weekly_event.valid?
    @weekly_event.description = "a" * 1001
    assert_not @weekly_event.valid?
  end

  test "location is optional and valid length" do
    @weekly_event.location = nil
    assert @weekly_event.valid?
    @weekly_event.location = "a" * 101
    assert_not @weekly_event.valid?
  end

  test "creatorid is required" do
    @weekly_event.creator_id = nil
    assert_not @weekly_event.valid?
  end

  test "groupid is required" do
    @weekly_event.group_id = nil
    assert_not @weekly_event.valid?
  end

  test "With frequency returns correct" do
    assert_includes Event.with_frequency(:monthly), @monthly_event
    assert_not_includes Event.with_frequency(:monthly), @weekly_event
    assert_not_includes Event.with_frequency(:monthly), @one_off_event
    assert_includes Event.with_frequency(:weekly), @weekly_event
    assert_not_includes Event.with_frequency(:weekly), @monthly_event
    assert_not_includes Event.with_frequency(:weekly), @one_off_event
    assert_includes Event.with_frequency(:once), @one_off_event
    assert_not_includes Event.with_frequency(:once), @monthly_event
    assert_not_includes Event.with_frequency(:once), @weekly_event
    assert_includes Event.with_frequency, @weekly_event
    assert_includes Event.with_frequency, @monthly_event
  end

  test "visibleto returns correct" do
    user = users(:testuser_two)
    visible_events = Event.visible_to(user)
    assert_includes visible_events, events(:event_one)
    assert_includes visible_events, events(:event_three)
    assert_not_includes visible_events, events(:event_two)
  end

  test "get_events_between_dates returns correct" do
    range_start = Date.parse("2025-06-01")
    range_end = Date.parse("2025-06-02")
    returned_events = Event.get_events_between_dates(range_start, range_end)
    assert_includes returned_events, events(:event_one)
    assert_not_includes returned_events, events(:event_two)
    assert_not_includes returned_events, events(:event_three)
  end

  test "is_on returns correct" do
    assert @one_off_event.is_on?(Date.parse("2025-06-03"))
  end
end
