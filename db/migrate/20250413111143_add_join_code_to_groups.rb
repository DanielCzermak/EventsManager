class AddJoinCodeToGroups < ActiveRecord::Migration[8.0]
  def change
    add_column :groups, :joinCode, :string, null: false, default: "123"
  end
end
