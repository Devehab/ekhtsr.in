class EditAdminAndLockedCols < ActiveRecord::Migration
  def change
    change_column_default(:users, :admin, false)
    change_column_default(:users, :locked, false)
  end
end
