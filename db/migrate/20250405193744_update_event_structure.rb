class UpdateEventStructure < ActiveRecord::Migration[8.0]
  def change
    change_table :events do |t|
      # Rename user_id to creator_id if needed
      if column_exists?(:events, :user_id) && !column_exists?(:events, :creator_id)
        t.rename :user_id, :creator_id
      elsif !column_exists?(:events, :creator_id)
        t.references :creator, foreign_key: { to_table: :users }, null: false
      end

      # Rename date fields if needed
      if column_exists?(:events, :start_datetime) && !column_exists?(:events, :start_date)
        t.rename :start_datetime, :start_date
      end

      if column_exists?(:events, :end_datetime) && !column_exists?(:events, :end_date)
        t.rename :end_datetime, :end_date
      end

      # Make description nullable
      if column_exists?(:events, :description)
        change_column_null :events, :description, true
      end

      # Make location nullable
      if column_exists?(:events, :location)
        change_column_null :events, :location, true
      end

      # Make end_date nullable
      if column_exists?(:events, :end_date)
        change_column_null :events, :end_date, true
      end

      # Add indexes if needed
      add_index :events, :start_date unless index_exists?(:events, :start_date)
      add_index :events, :name unless index_exists?(:events, :name)
    end
  end
end
