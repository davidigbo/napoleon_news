class CreateQuestions < ActiveRecord::Migration[7.2]
  def change
    create_table :questions do |t|
      t.string :question_text
      t.string :correct_answer

      t.timestamps
    end
  end
end
