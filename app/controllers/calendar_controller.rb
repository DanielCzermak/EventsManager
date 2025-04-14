class CalendarController < ApplicationController
  def index
    @user_groups = current_user.groups

    @group_filter = params[:group_filter] || "all"

    @user_events = Event.visible_to(current_user)

    if @group_filter != "all"
      if current_user.groups.exists?(id: @group_filter)
        @user_events = @user_events.where(group_id: @group_filter)
      else
        flash[:alert] = "Invalid filter!"
        @group_filter = "all"
      end
    end

    if @user_events.empty?
      flash[:alert] = "Current filter includes no events!"
    end

  end
end
