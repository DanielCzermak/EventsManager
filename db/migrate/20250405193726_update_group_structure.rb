class UpdateGroupStructure < ActiveRecord::Migration[8.0]
  def change
    change_table :groups do |t|
      # Rename creator_id to owner_id
      if column_exists?(:groups, :creator_id) && !column_exists?(:groups, :owner_id)
        t.rename :creator_id, :owner_id
      elsif !column_exists?(:groups, :owner_id)
        t.references :owner, foreign_key: { to_table: :users }, null: false
      end

      # Ensure visibility is an integer for enum
      unless column_exists?(:groups, :visibility) && column_for_attribute(:groups, :visibility).type == :integer
        if column_exists?(:groups, :visibility)
          t.remove :visibility
          t.integer :visibility, default: 0, null: false
        else
          t.integer :visibility, default: 0, null: false
        end
      end
    end
  end

  private

  def column_for_attribute(table, column)
    connection.columns(table).find { |c| c.name == column.to_s }
  end
end