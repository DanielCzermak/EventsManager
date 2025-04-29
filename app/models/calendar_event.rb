class CalendarEvent
  attr_reader :event, :start_time, :end_time
  delegate :id, :name, :group, :location, :frequency, to: :event

  def initialize(event, start_date, end_date = nil)
    @event = event
    @start_time = start_date
    @end_time = end_date if end_date
  end
end
