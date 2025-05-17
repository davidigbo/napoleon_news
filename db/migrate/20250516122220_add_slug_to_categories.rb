class AddSlugToCategories < ActiveRecord::Migration[7.2]
  def change
    add_column :categories, :slug, :string
    add_index :categories, :slug, unique: true
  end
end
