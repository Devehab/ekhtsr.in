class AddUserUrlsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :user_urls_count, :integer, :default => 0
    
    User.reset_column_information
    User.all.each do |p|
      User.update_counters p.id, :user_urls_count => p.user_urls.length
    end
  end
end
