require "test_helper"

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(
      email: "testuser@example.com",
      username: "testuser",
      date_of_birth: Date.new(1990, 1, 1),
      password: "testpass",
      role: "user"
    )
  end

  test "test user is valid" do 
    assert @user.valid?
  end

  test "email is required" do
    @user.email = nil
    assert_not @user.valid?
  end

  test "email is unique" do
    dupe = @user.dup
    @user.save!
    assert_not dupe.valid?
  end

  test "email is email format" do
    @user.email = "invalidformatemail"
    assert_not @user.valid?
  end

  test "email is valid length" do
    @user.email = "a" * 45 + "@example.com"
    assert_not @user.valid?
  end

  test "username is required" do
    @user.username = nil
    assert_not @user.valid?
  end

  test "username is unique" do
    dupe = @user.dup
    @user.save!
    dupe.email = "diffemail@ex.com"
    dupe.username = @user.username.upcase
    assert_not dupe.valid?
  end

  test "username is valid length" do
    @user.username = "aa"
    assert_not @user.valid?
    @user.username = "a" * 29
  end

  test "username is valid format" do
    @user.username = "!invalid!"
    assert_not @user.valid?
  end

  test "dateofbirth is required" do
    @user.date_of_birth = nil
    assert_not @user.valid?
  end
end
