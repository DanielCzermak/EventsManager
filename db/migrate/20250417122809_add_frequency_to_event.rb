class AddFrequencyToEvent < ActiveRecord::Migration[8.0]
  def change
    add_column :events, :frequency, :integer, null: false, default: 0
  end
end
