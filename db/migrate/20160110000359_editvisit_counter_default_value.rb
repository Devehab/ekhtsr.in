class EditvisitCounterDefaultValue < ActiveRecord::Migration
  def change
    change_column_default :user_urls, :visit_counter, 0
  end
end
