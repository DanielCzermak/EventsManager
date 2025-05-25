require "test_helper"

class GroupMembershipTest < ActiveSupport::TestCase
  test "fixture memberships are valid" do
    assert group_memberships(:membership_one).valid?
    assert group_memberships(:membership_two).valid?
    assert group_memberships(:membership_three).valid?
  end

  test "require user ID" do
    group_memberships(:membership_one).user_id = nil
    assert_not group_memberships(:membership_one).valid?
  end

  test "require group ID" do
    group_memberships(:membership_one).group_id = nil
    assert_not group_memberships(:membership_one).valid?
  end

  test "duplicates not allowed" do
    mb = group_memberships(:membership_one)
    mb.save!
    dupe = mb.dup
    assert_not dupe.valid?
  end
end
