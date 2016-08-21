class CreateAnonymousUrls < ActiveRecord::Migration
  def change
    create_table :anonymous_urls do |t|
      t.text     :url
      t.string   :unique_id
      t.integer  :visit_counter, default: 0

      t.datetime :created_at
    end
  end
end
