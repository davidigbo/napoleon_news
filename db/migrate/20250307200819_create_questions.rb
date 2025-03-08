class CreateQuestions < ActiveRecord::Migration[7.2]
  def change
    create_table :questions do |t|
      t.text :question_text
      t.string :correct_answer
      t.string :api_question_id
      t.text :incorrect_answers

      t.timestamps
    end
    add_index :questions, :api_question_id
  end
end
