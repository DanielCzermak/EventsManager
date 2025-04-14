# Class for join table containing User-Group many-many relationship
# - validates for avoiding duplicate group memberships
class GroupMembership < ApplicationRecord
  belongs_to :user
  belongs_to :group

  validates :user_id, :group_id, presence: true

  validates :user_id, uniqueness: { scope: :group_id, message: " is already a member of group" }
end
