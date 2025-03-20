# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Create Categories
categories = [
  { title: 'Features', children: %w[Interview Stories CSR] },
  { title: 'Leadership', children: %w[Transformational Leaders Governance Legal] },
  { title: 'Business', children: %w[Finance SMEs Innovation Listings] },
  { title: 'Society', children: %w[Men Youth]},
  { title: 'News', children: %w[Trending Entertainment Tech Sports Culture]},
  { title: 'Carousel', children: []},
  { title: 'Others', children: []}
]

categories.each do |category_data|
  category = Category.find_or_create_by!(name: category_data[:title])
  children_params = category_data[:children].map {|name| { name: name, parent_id: category.id } }
  Category.create(children_params)
end

# %[admin editor author writer].each do |role|
#   create roles  
# end

sample_questions = [
  {
    question_text: "What is the capital of France?",
    correct_answer: "Paris",
    incorrect_answers: ["London", "Berlin", "Madrid"],
    api_question_id: "q1"
  },
  {
    question_text: "Who wrote 'Romeo and Juliet'?",
    correct_answer: "William Shakespeare",
    incorrect_answers: ["Charles Dickens", "Jane Austen", "Mark Twain"],
    api_question_id: "q2"
  },
  # Add more sample questions as needed
]

sample_questions.each do |q|
  Question.find_or_create_by(api_question_id: q[:api_question_id]) do |question|
    question.question_text = q[:question_text]
    question.correct_answer = q[:correct_answer]
    question.incorrect_answers = q[:incorrect_answers]
  end
end

puts "Seeded #{Question.count} questions"