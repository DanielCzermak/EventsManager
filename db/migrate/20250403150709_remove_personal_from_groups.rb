class RemovePersonalFromGroups < ActiveRecord::Migration[8.0]
  def change
    remove_column :groups, :personal

    add_column :groups, :visibility, :integer, :null => false
  end
end
