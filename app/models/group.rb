# Group model
# - attr: name:string, description:text, visibility:integer, owner_id:bigint
# - when a new Group is created the owner is also added as a member to the join table
class Group < ApplicationRecord
  enum :visibility, { everyone: 0, secret: 1, personal: 2 }

  belongs_to :owner, class_name: "User", foreign_key: "owner_id"

  has_many :group_memberships, dependent: :destroy
  has_many :users, through: :group_memberships

  has_many :events, dependent: :destroy

  validates :name, presence: true, uniqueness: true, length: { in: 3..50 }
  validates :description, length: { maximum: 1000 }, allow_blank: true
  validates :owner_id, presence: true
  validates :visibility, inclusion: { in: visibilities.keys }
  validates :join_code, presence: true, uniqueness: true, length: { is: 8 }

  before_validation :generate_join_code, on: :create
  after_create :add_owner_as_member

  scope :public_groups, -> { where(visibility: :everyone) }

  private

  def add_owner_as_member
    group_memberships.find_or_create_by!(user: owner)
  end

  def generate_join_code
    self.join_code = SecureRandom.alphanumeric(8).upcase
  end
end
