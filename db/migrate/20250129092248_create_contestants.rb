class CreateContestants < ActiveRecord::Migration[7.2]
  def change
    create_table :contestants do |t|
      t.references :user, null: false, foreign_key: true
      t.references :contest, null: false, foreign_key: true
      t.text :description
      t.integer :approved
      t.integer :approved_by
      t.datetime :approved_at

      t.timestamps
    end
  end
end
