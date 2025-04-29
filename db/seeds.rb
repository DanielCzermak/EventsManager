# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

Event.destroy_all
GroupMembership.destroy_all
Group.destroy_all
User.destroy_all

test_users_data = [
  {
    email: "test1@test.com",
    password: "test123",
    username: "testuser1",
    date_of_birth: Date.new(2004, 2, 22)
  },
  {
    email: "test2@test.com",
    password: "test234",
    username: "testuser2",
    date_of_birth: Date.new(2001, 9, 12)
  },
  {
    email: "test3@test.com",
    password: "test345",
    username: "testuser3",
    date_of_birth: Date.new(2000, 1, 19)
  }
]

test_users = test_users_data.map { |user_data| User.create!(user_data) }
test1, test2, test3 = test_users

test_groups_data = [
  {
    name: "Common Test group",
    description: "common test group description",
    visibility: :everyone,
    owner: test1
  },
  {
    name: "Secret test group",
    description: "secret test group description",
    visibility: :secret,
    owner: test2
  }
]

test_groups = test_groups_data.map { |group_data| Group.create!(group_data) }
common_group, secret_group = test_groups

GroupMembership.create!(
  user: test2,
  group: common_group
)
GroupMembership.create!(
  user: test3,
  group: secret_group
)

test_events_data = [
  {
    name: "Single day event",
    description: "single day event desc",
    start_date: DateTime.now + 1.days + 3.hours,
    end_date: DateTime.now + 1.days + 4.hours,
    location: "somewhere",
    creator: test1,
    group: common_group,
    frequency: :once
  },
  {
    name: "Multiday event",
    description: "multiday event desc",
    start_date: DateTime.now + 3.days,
    end_date: DateTime.now + 7.days,
    location: "test location",
    creator: test2,
    group: secret_group,
    frequency: :once
  },
  {
    name: "test3 personal event",
    description: "test 3's personal event",
    start_date: DateTime.now + 2.days + 2.hours,
    end_date: DateTime.now + 3.days - 6.hours,
    location: "test3's location",
    creator: test3,
    group: test3.owned_groups.where(visibility: :personal).first,
    frequency: :once
  },
  {
    name: "far away event",
    description: "far away",
    start_date: DateTime.now + 9.days + 3. hours,
    end_date: DateTime.now + 12.days + 9.hours,
    location: "a location",
    creator: test1,
    group: common_group,
    frequency: :once
  },
  {
    name: "weekly repeating event",
    description: "weekly repeating",
    start_date: DateTime.now + 1.days + 2. hours,
    end_date: DateTime.now + 1.days + 2.hours + 10.minutes,
    location: "a location",
    creator: test1,
    group: common_group,
    frequency: :weekly
  },
  {
    name: "monthly repeating event",
    description: "monthly repeating",
    start_date: DateTime.now + 3.days + 2. hours,
    end_date: DateTime.now + 4.days + 2.hours + 10.minutes,
    location: "a location",
    creator: test1,
    group: common_group,
    frequency: :monthly
  },
  {
    name: "yearly repeating event",
    description: "yearly repeating",
    start_date: DateTime.now + 7.days + 2. hours,
    end_date: DateTime.now + 7.days + 2.hours + 10.minutes,
    location: "a location",
    creator: test1,
    group: common_group,
    frequency: :yearly
  }
]

test_events_data.each { |event_data| Event.create!(event_data) }
