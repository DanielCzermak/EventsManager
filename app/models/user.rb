# User model created with devise
# - attr: email:string, username:string, date_of_birth:date, role:string
# - when a new user is created also creates a personal group for them
class User < ApplicationRecord
  enum :role, { user: "user", admin: "admin" }

  has_many :group_memberships, dependent: :destroy
  has_many :groups, through: :group_memberships
  has_many :owned_groups, class_name: "Group", foreign_key: :owner_id, dependent: :nullify

  has_many :created_events, class_name: "Event", foreign_key: :creator_id, dependent: :nullify

  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }, length: { in: 5..50 }
  validates :username, presence: true, uniqueness: { case_sensitive: false }, length: { in: 3..28 }
  validates_format_of :username, with: /\A[a-zA-Z0-9_.]+\z/, message: "username contains illegal character"
  validates :date_of_birth, presence: true

  after_create :create_personal_group

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  attr_writer :login
  def login
    @login || self.username || self.email
  end
  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if (login = conditions.delete(:login))
      where(conditions.to_h).where([ "username = :value OR email = :value", { value: login.downcase } ]).first
    elsif conditions.has_key?(:username) || conditions.has_key?(:email)
      where(conditions.to_h).first
    end
  end

  private

  def create_personal_group
    owned_groups.create!(
      name: "#{username}'s Personal Group",
      description: "Personal events for #{username}",
      visibility: :personal
    )
  end
end
