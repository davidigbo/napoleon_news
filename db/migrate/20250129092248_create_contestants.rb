class CreateContestants < ActiveRecord::Migration[7.2]
  def change
    create_table :contestants do |t|
      t.references :user, null: false, foreign_key: true
      t.references :contest, null: false, foreign_key: true
      t.references :approved_by, foreign_key: {to_table: 'users'}
      t.text :description
      t.integer :approved
      t.datetime :approved_at
      t.string :stage_name

      t.timestamps
    end
  end
end
