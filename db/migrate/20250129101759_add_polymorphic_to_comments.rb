class AddPolymorphicToComments < ActiveRecord::Migration[7.2]
  def change
    add_reference :comments, :commentable, polymorphic: true, null: false
  end
end
