class CreateUserUrls < ActiveRecord::Migration
  def change
    create_table :user_urls do |t|
      t.text :url
      t.string :unique_id
      t.integer :visit_counter
      t.integer :user_id

      t.datetime :created_at
    end
  end
end
