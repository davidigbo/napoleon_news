class CreateVotes < ActiveRecord::Migration[7.2]
  def change
    create_table :votes do |t|
      t.references :contestant, null: false, foreign_key: true
      t.references :voter, foreign_key: { to_table: 'users' }, null: false
      t.references :contest, null: false, foreign_key: true

      t.timestamps
    end
  end
end
