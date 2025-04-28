class EventsController < ApplicationController
  before_action :event_auth_check, only: [ :edit, :update, :destroy ]
  before_action :event_length_check, only: [ :create, :update ]
  before_action :event_show_check, only: [ :show ]

  def index
    @user_events = Event.visible_to(current_user)

    @user_groups = current_user.groups

    @temporal_filter = params[:temporal_filter] || "upcoming"
    @group_filter = params[:group_filter] || "all"
    @frequency_filter = params[:frequency_filter] || "all"

    case @temporal_filter
    when "upcoming"
      @user_events = @user_events.upcoming.or(@user_events.where.not(frequency: :once))
    when "past"
      @user_events = @user_events.past.where(frequency: :once)
    end

    if @group_filter != "all"
      if current_user.groups.exists?(id: @group_filter)
        @user_events = @user_events.where(group_id: @group_filter)
      else
        flash[:alert] = "Invalid filter!"
        @group_filter = "all"
      end
    end

    if @frequency_filter != "all"
      @user_events = @user_events.with_frequency(@frequency_filter.to_sym)
    end

    @user_events = @user_events.order(start_date: (@temporal_filter == "upcoming" ? :asc : :desc))

  end

  def show
    @event = Event.find(params[:id])
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
          .permit(:name, :description, :start_date, :end_date, :location, :group_id, :frequency)
  end

  def event_auth_check
    @event = Event.find(params[:id])
    unless @event.creator == current_user || @event.group.owner == current_user
      flash[:alert] = "You aren't authorized to perform this action!"
      Rails.logger.warn("Illegal action attempted on event #{@event.id} by user #{current_user}!!")
      redirect_to events_index_path
    end
  end

  def event_length_check
    return unless params[:event] && params[:event][:frequency]

    frequency = params[:event][:frequency].to_sym
    start_date = params[:event][:start_date].to_date
    end_date = params[:event][:end_date].to_date

    return if (start_date && end_date.nil?) || !Event.frequencies.include?(frequency)

    max_days = {
      once: 365,
      weekly: 7,
      monthly: 31,
      yearly: 365
    }

    if (end_date - start_date) + 1 > max_days[frequency]
      flash[:alert] = "Event duration is too long for #{frequency} frequency. Maximum is #{max_days[frequency]} days."
      redirect_back fallback_location: events_index_path
    end
  end

  def event_show_check
    @event = Event.find(params[:id])
    unless @event.group.users.includes(current_user)
      Rails.logger.warn("Illegal action attempted on event #{@event.id} by user #{current_user}!!")
      redirect_to events_index_path
    end
  end

end
