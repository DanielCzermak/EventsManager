# Creates unique CalendarEvent instances for all events occurring within the date_range parameter
# Handles reoccurring, multiday and partially in range events
class Calendar::EventFactory
  def self.produce_events_for_date_range(date_range, events)
    return nil unless date_range&.any? && events&.any?

    events_for_range = {}

    date_range.each do |date|
      events.each do |event|
        if event.is_on?(date)
          if event.once?
            # If event only occurs once key can just be the actual event id
            event_key = event.id
          else
            # If event is reoccurring we need to find the occurrence's start date from
            # the possible range and make that the key with the event Id
            duration = ((event.end_date || event.start_date) - event.start_date).to_i.seconds

            search_range_start = date.beginning_of_day - duration
            search_range_end = date.end_of_day

            actual_start_date = event.schedule.occurrences_between(search_range_start,search_range_end).first

            event_key = "#{event.id}-#{actual_start_date.to_i}"
          end

          # Add event to hash if key isn't in it
          unless events_for_range[event_key]
            if event.once?
              start_date = event.start_date
              end_date = event.end_date
            else
              start_date = actual_start_date
              end_date = actual_start_date + duration if duration > 0
            end
            events_for_range[event_key] = CalendarEvent.new(event, start_date, end_date)
          end
        end
      end
    end
    events_for_range.values.flatten
  end
end
