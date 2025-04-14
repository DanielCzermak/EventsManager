class MinorImprovements < ActiveRecord::Migration[8.0]
  def change
    rename_column :groups, :joinCode, :join_code

    add_foreign_key :group_memberships, :users
    add_foreign_key :group_memberships, :groups

    add_check_constraint :events, "end_date is null or end_date > start_date", name: "check_end_after_start"

    add_index :groups, :visibility

    change_column :users, :username, :string, limit: 28
    change_column :users, :email, :string, limit: 50
    change_column :groups, :name, :string, limit: 50
    change_column :groups, :description, :text, limit: 1000
    change_column :events, :name, :string, limit: 64
    change_column :events, :description, :text, limit: 1000
    change_column :events, :location, :string, limit: 100

  end
end
