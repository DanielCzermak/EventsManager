# Event model
# - attr: name:string, description:text, start_date:datetime, end_date:datetime,
#         location:string, creator_id:bigint, group_id:bigint
class Event < ApplicationRecord
  enum :frequency, { once: 0, weekly: 1, monthly: 2, yearly: 3 }

  belongs_to :group
  belongs_to :creator, class_name: "User"

  validates :name, :start_date, presence: true, length: { in: 3..64 }
  validates :description, length: { maximum: 1000 }, allow_blank: true
  validates :location, length: { maximum: 100 }, allow_blank: true
  validates :creator_id, :group_id, presence: true
  validate :end_date_after_start_date, if: -> { end_date.present? }

  scope :upcoming, -> { where("start_date >= ?", Time.current).order(start_date: :asc) }
  scope :past, -> { where("start_date <  ?", Time.current).order(start_date: :desc) }

  scope :with_frequency, ->(frequency = nil) {
    case frequency
    when :once
      where(frequency: :once)
    when :weekly
      where(frequency: :weekly)
    when :monthly
      where(frequency: :monthly)
    when :yearly
      where(frequency: :yearly)
    else
      where.not(frequency: :once)
    end
  }

  scope :visible_to, ->(user) {
    return none if user.nil?
    joins(:group).where(groups: { id: user.group_ids })
  }

  # Gets all events that fully or partially fall within parameter range
  def self.get_events_between_dates(range_start, range_end)
    # Get one time events in range
    one_time_events = with_frequency(:once).where("start_date <= ?", range_end)
                                           .where("(end_date IS NULL OR end_date >= ?)", range_start)
    # Get recurring events which have started
    recurring_events = with_frequency.where("start_date <= ?", range_end)

    one_time_events.or(recurring_events)
  end

  # Checks if event occurs on the date parameter
  def is_on?(date)
    if once?
      # One time event: check if date falls within event range
      event_start = start_date.to_date
      event_end = (end_date || start_date).to_date
      date >= event_start && date <= event_end
    else
      # Recurring event: use IceCube schedule, but subtract event length from start to correctly handle multiday events
      duration = ((end_date || start_date) - start_date).to_i.seconds

      # Get start and end of day so we can disregard the time component
      date_range_start = date.beginning_of_day
      date_range_end = date.end_of_day

      # Use IceCube to check if the event occurs within the range minus event duration
      schedule.occurrences_between(date_range_start - duration, date_range_end).any? do |occurrence|
        occurrence_start = occurrence.to_date
        occurrence_end = (occurrence + duration).to_date
        date >= occurrence_start && date <= occurrence_end
      end
    end
  end

  # Get IceCube schedule for event instance
  def schedule
    return nil if once?

    schedule = IceCube::Schedule.new(start_date)

    case frequency.to_sym
    when :weekly then schedule.add_recurrence_rule(IceCube::Rule.weekly)
    when :monthly then schedule.add_recurrence_rule(IceCube::Rule.monthly.day_of_month(start_date.day))
    when :yearly then schedule.add_recurrence_rule(IceCube::Rule.yearly.month_of_year(start_date.month).day_of_month(start_date.day))
    else nil
    end
    schedule
  end

  # Needed for simple calendar
  def start_time
    start_date
  end
  def end_time
    end_date
  end

  private

  def end_date_after_start_date
    if end_date <= start_date
      errors.add(:end_date, " must be after the start date")
    end
  end

end
