class AddMissingColumnsToGroup < ActiveRecord::Migration[8.0]
  def change
    add_column :groups, :creator_id, :bigint, null: false
    add_foreign_key :groups, :users, column: :creator_id
  end
end
