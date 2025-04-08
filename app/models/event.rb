# Event model
# - attr: name:string, description:text, start_date:datetime, end_date:datetime,
#         location:string, creator_id:bigint, group_id:bigint
class Event < ApplicationRecord
  belongs_to :group
  belongs_to :creator, class_name: "User"

  validates :name, :start_date, presence: true
  validate :end_date_after_start_date, if: -> { end_date.present? }

  scope :upcoming, -> { where("start_date > ?", Time.current).order(start_date: :asc) }
  scope :past, -> { where("end_date < ?", Time.current).order(start_date: :desc) }

  scope :visible_to, ->(user) {
    return none if user.nil?
    joins(:group).where(group_id: user.group_ids)
  }

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
