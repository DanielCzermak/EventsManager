class EventsController < ApplicationController
  before_action :event_auth_check, only: [ :edit, :update, :destroy ]

  def index
    @user_groups = current_user.groups

    @temporal_filter = params[:temporal_filter] || "upcoming"
    @group_filter = params[:group_filter] || "all"

    @user_events = Event.visible_to(current_user)

    case @temporal_filter
    when "upcoming"
      @user_events = @user_events.upcoming
    when "past"
      @user_events = @user_events.past
    end

    if @group_filter != "all"
      if current_user.groups.exists?(id: @group_filter)
        @user_events = @user_events.where(group_id: @group_filter)
      else
        flash[:alert] = "Invalid filter!"
        @group_filter = "all"
      end
    end

    @user_events = @user_events.order(start_date: (@temporal_filter == "upcoming" ? :asc : :desc))

  end

  def new
    @event = Event.new
  end

  def create
    @event = Event.new(event_params)
    @event.creator = current_user

    if @event.save
      flash[:success] = "#{@event.name} successfully created!"
      redirect_to events_index_path
    else
      flash[:alert] = "Failed to create event!"
      render :new
    end
  end

  def edit

  end

  def update
    if @event.update(event_params)
      flash[:success] = "Edits to #{@event.name} successfully saved!"
      redirect_to events_index_path
    else
      flash[:alert] = "Failed to save edits!"
      render :edit
    end
  end

  def destroy
    if @event.destroy
      flash[:success] = "Event successfully deleted!"
    else
      flash[:alert] = "Failed to delete #{@event.name}!"
    end
    redirect_to events_index_path
  end

  private

  def event_params
    params.require(:event)
          .permit(:name, :description, :start_date, :end_date, :location, :group_id)
  end

  def event_auth_check
    @event = Event.find(params[:id])
    unless @event.creator == current_user || @event.group.owner == current_user
      flash[:alert] = "You aren't authorized to perform this action!"
      Rails.logger.warn("Illegal action attempted on event #{@event.id}!!")
      redirect_to events_index_path
    end
  end

end
