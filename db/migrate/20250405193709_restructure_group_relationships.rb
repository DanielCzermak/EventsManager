class RestructureGroupRelationships < ActiveRecord::Migration[8.0]
  def change
    # Drop the adminships table if it exists
    drop_table :adminships if table_exists?(:adminships)

    # Rename groups_users to group_memberships and add needed columns
    rename_table :groups_users, :group_memberships unless table_exists?(:group_memberships)

    # Add primary key and timestamps to group_memberships
    if table_exists?(:group_memberships)
      change_table :group_memberships do |t|
        unless column_exists?(:group_memberships, :id)
          t.primary_key :id, first: true unless column_exists?(:group_memberships, :id)
        end

        t.timestamps unless column_exists?(:group_memberships, :created_at)
        t.datetime :joined_at, default: -> { 'CURRENT_TIMESTAMP' } unless column_exists?(:group_memberships, :joined_at)
      end

      # Add index to prevent duplicates if not exists
      add_index :group_memberships, [:user_id, :group_id], unique: true unless index_exists?(:group_memberships, [:user_id, :group_id])
    end
  end
end
