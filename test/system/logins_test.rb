require "application_system_test_case"

class LoginsTest < ApplicationSystemTestCase
  test "login test" do
    visit "http://localhost:3000"
    assert_selector "Input", text: "Login"
  end
end
