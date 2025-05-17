class QuizService
  require "http"

  def self.fetch_questions(num_questions = 34)
    # Using the Open Trivia Database API as an example
    url = "https://opentdb.com/api.php?amount=#{num_questions}&type=multiple"
    response = HTTP.get(url)
    
    if response.status.success?
      data = JSON.parse(response.body.to_s)
      
      if data["response_code"] == 0
        return data["results"].map do |question|
          {
            question_text: question["question"],
            correct_answer: question["correct_answer"],
            api_question_id: Digest::MD5.hexdigest(question["question"]),
            incorrect_answers: question["incorrect_answers"]
          }
        end
      end
    end
    
    # Return empty array if API call fails
    []
  end
  
  def self.create_quiz_with_questions(user, num_questions = 34)
    quiz = user.quizzes.create(completed: false)
    api_questions = fetch_questions(num_questions)
    
    # debugger 
    api_questions.each do |api_question|
      # debugger
      question = Question.find_or_create_from_api(api_question)
      quiz.quiz_questions.create(question: question)
    end
    
    quiz
  end
end
