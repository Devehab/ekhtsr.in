class AddTitleToUserUrl < ActiveRecord::Migration
  def change
    add_column :user_urls, :title, :string, :default => ""
  end
end
