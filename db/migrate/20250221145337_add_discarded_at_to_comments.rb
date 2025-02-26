class AddDiscardedAtToComments < ActiveRecord::Migration[7.2]
  def change
    add_column :comments, :discarded_at, :datetime
    add_index :comments, :discarded_at
  end
end
