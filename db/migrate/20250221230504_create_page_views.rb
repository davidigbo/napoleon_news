class CreatePageViews < ActiveRecord::Migration[7.2]
  def change
    create_table :page_views do |t|
      t.string :page_type
      t.integer :page_id
      t.json :metadata
      t.references :user, null: true, foreign_key: true
      t.datetime :visited_at
      t.string :ip_address

      t.timestamps
    end
  end
end
