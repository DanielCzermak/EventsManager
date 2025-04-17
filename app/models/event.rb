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

  scope :upcoming, -> { where("start_date > ?", Time.current).order(start_date: :asc) }
  scope :past, -> { where("end_date < ?", Time.current).order(start_date: :desc) }

  scope :with_frequency, ->(frequency) {
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

  def self.get_events_between_dates(start_date, end_date)
    where("(frequency = 0 and start_date between ? and ?) or (frequency > 0 and start_date <= ?)", start_date, end_date, end_date)
  end

  def is_on?(date)
    event_date = start_date.to_date
    return event_date == date if once?
    return false if event_date > date
    case frequency.to_sym
    when :weekly then is_same_weekday?(event_date, date)
    when :monthly then is_same_monthday?(event_date, date)
    when :yearly then is_same_yearday?(event_date, date)
    else
      false
    end
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

  def is_same_weekday?(event_date, date)
    event_date.wday == date.wday
  end

  def is_same_monthday?(event_date, date)
    event_date.day == date.day
  end

  def is_same_yearday?(event_date, date)
    event_date.month == date.month && is_same_monthday?(event_date, date)
  end

  def date_range
    start_date..end_date
  end

end
