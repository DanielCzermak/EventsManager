class HomeController < ApplicationController
  def index
    this_week = DateTime.now.beginning_of_day..(DateTime.now + 7.days).end_of_day
    @events_this_week = Event.visible_to(current_user).where(
      "start_date between ? and ?", this_week.begin, this_week.end
    ).order(start_date: :asc)
  end
end
