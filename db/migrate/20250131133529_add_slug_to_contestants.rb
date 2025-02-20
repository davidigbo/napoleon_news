class AddSlugToContestants < ActiveRecord::Migration[7.2]
  def change
    add_column :contestants, :slug, :string
    add_index :contestants, :slug, unique: true
  end
end
