class UpdateComments < ActiveRecord::Migration[7.2]
  def up
    # Update existing comments to use polymorphic association
    execute <<-SQL
      UPDATE comments
      SET commentable_type = 'Article', commentable_id = article_id
      WHERE article_id IS NOT NULL;
    SQL

    # Remove the old columns
    remove_column :comments, :article_id
    remove_column :comments, :content
  end

  def down
    # Add the columns back (if we need to rollback)
    add_column :comments, :article_id, :bigint
    add_column :comments, :content, :text

    # Restore article_id from commentable_id where applicable
    execute <<-SQL
      UPDATE comments
      SET article_id = commentable_id
      WHERE commentable_type = 'Article';
    SQL
  end
end
