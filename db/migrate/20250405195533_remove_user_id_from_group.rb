class RemoveUserIdFromGroup < ActiveRecord::Migration[8.0]
  def change
    remove_reference :groups, :user, foreign_key: true, index: true
  end
end
