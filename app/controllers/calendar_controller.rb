class CalendarController < ApplicationController
  def index
    @user_groups = current_user.groups

    @temporal_filter = params[:temporal_filter] || "upcoming"
    @group_filter = params[:group_filter] || "all"

    @user_events = Event.visible_to(current_user)

    if @group_filter != "all"
      @user_events = @user_events.where(group_id: @group_filter)
    end

  end
end
