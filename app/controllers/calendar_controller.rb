class CalendarController < ApplicationController
  def index
    @start_date = params[:start_date]&.to_date || Date.today

    @date_range = get_calendar_range(@start_date)

    @user_events = Event.visible_to(current_user).get_events_between_dates(@date_range.first, @date_range.last)

    @user_groups = current_user.groups
    @group_filter = params[:group_filter] || "all"

    if @group_filter != "all"
      if current_user.groups.exists?(id: @group_filter)
        @user_events = @user_events.where(group_id: @group_filter)
      else
        flash[:alert] = "Invalid filter!"
        @group_filter = "all"
      end
    end

    @events_in_range = get_events_for_range
  end

  private

  # Produces calendar date range the same way as simple_calendar
  def get_calendar_range(date)
    date.beginning_of_month.beginning_of_week..date.end_of_month.end_of_week
  end

  # Constructs a hash of each day within the range with the events occurring on that day
  def get_events_for_range
    events_for_range = {}
    @date_range.each do |date|
      events_for_date = []
      @user_events.each do |event|
        events_for_date << event if event.is_on?(date)
      end
      events_for_range[date] = events_for_date if events_for_date.any?
    end
    events_for_range
  end

end
