class AddAnonymizeToArticles < ActiveRecord::Migration[7.2]
  def change
    add_column :articles, :anonymize, :boolean, default: false
  end
end
