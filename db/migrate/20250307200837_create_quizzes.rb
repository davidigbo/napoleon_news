class CreateQuizzes < ActiveRecord::Migration[7.2]
  def change
    create_table :quizzes do |t|
      t.boolean :completed
      t.integer :score
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
