require "test_helper"

class GroupTest < ActiveSupport::TestCase
  def setup
    @group_one = groups(:group_one)
    @group_two = groups(:group_two)
  end

  test "are fixtures valid" do
    assert @group_one.valid?
    assert @group_two.valid?
  end

  test "name required" do
    @group_one.name = nil
    assert_not @group_one.valid?
  end

  test "name unique" do
    dupe = @group_one.dup
    dupe.name = @group_one.name
    assert_not dupe.valid?
  end

  test "name valid length" do
    @group_one.name = "a" * 2
    assert_not @group_one.valid?
    @group_one.name = "a" * 5
    assert @group_one.valid?
    @group_one.name = "a" * 51
    assert_not @group_one.valid?
  end

  test "description is optional and valid length" do
    @group_one.description = nil
    assert @group_one.valid?
    @group_one.description = "a" * 1001
    assert_not @group_one.valid?
  end

  test "owner_id is required" do
    @group_one.owner_id = nil
    assert_not @group_one.valid?
  end

  test "join_code is required" do
    @group_one.join_code = nil
    assert_not @group_one.valid?
  end

  test "join_code is valid length" do
    @group_one.join_code = "this is not 8 characters"
    assert_not @group_one.valid?
  end

  test "join_code is generated before validation" do
    new_group = Group.create!(
      name: "testgroup",
      owner: @group_one.owner,
      visibility: 1
    )
    assert_not_nil new_group.join_code
    assert_equal 8, new_group.join_code.length
  end

  test "public groups scope return only public groups" do
    public_groups = Group.public_groups
    assert_includes public_groups, @group_one
    assert_not_includes public_groups, @group_two
  end
end
