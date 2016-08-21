class AddPasswordToUserUrl < ActiveRecord::Migration
  def change
    add_column :user_urls, :password, :string, :default => ""
  end
end
