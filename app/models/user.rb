class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  enum :role, { user: "user", admin: "admin" }

  has_many :group_memberships, dependent: :destroy
  has_many :groups, through: :group_memberships
  
  has_many :owned_groups, class_name: "Group", foreign_key: :owner_id, dependent: :nullify

  has_many :created_events, class_name: "Event", foreign_key: :creator_id, dependent: :nullify

  validates :username, presence: true, uniqueness: true
  validates :date_of_birth, presence: true

  after_create :create_personal_group

  private

  def create_personal_group
    owned_groups.create!(
      name: "#{username}'s Personal Group",
      description: "Personal events for #{username}",
      visibility: :personal
    )
  end
end
