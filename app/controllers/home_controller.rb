class HomeController < ApplicationController
  def index
    this_week = Date.today..(Date.today + 7.days)
    user_events = Event.visible_to(current_user).get_events_between_dates(this_week.begin, this_week.end)
    @events_this_week = Calendar::EventFactory.produce_events_for_date_range(this_week, user_events)
  end
end
