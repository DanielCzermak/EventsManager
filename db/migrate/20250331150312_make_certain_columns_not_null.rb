class MakeCertainColumnsNotNull < ActiveRecord::Migration[8.0]
  def up
    change_column_null :events, :name, false
    change_column_null :events, :description, false
    change_column_null :events, :start_datetime, false
    change_column_null :events, :end_datetime, false
    change_column_null :events, :location, false

    change_column_null :groups, :name, false

    change_column_null :users, :username, false
    change_column_null :users, :date_of_birth, false
  end
end
