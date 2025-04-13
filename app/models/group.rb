# Group model
# - attr: name:string, description:text, visibility:integer, owner_id:bigint
# - when a new Group is created the owner is also added as a member to the join table
class Group < ApplicationRecord
  enum :visibility, { everyone: 0, secret: 1, personal: 2 }

  belongs_to :owner, class_name: "User", foreign_key: "owner_id"

  has_many :group_memberships, dependent: :destroy
  has_many :users, through: :group_memberships

  has_many :events, dependent: :destroy

  validates :name, presence: true, uniqueness: true
  validates :visibility, presence: true

  before_create :generate_join_code
  after_create :add_owner_as_member

  private

  def add_owner_as_member
    unless group_memberships.exists?(user_id: owner.id)
      group_memberships.create!(user: owner)
    end
  end

  def generate_join_code
    self.joinCode = SecureRandom.alphanumeric(8).upcase
  end
end
