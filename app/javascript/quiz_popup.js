// app/javascript/quiz_popup.js
const QuizPopup = {
  initialized: false,
  
  init() {
    // Prevent multiple initializations
    if (this.initialized) {
      return;
    }
    
    this.initialized = true;
    this.startTimeTracker();
    this.setupEventListeners();
    this.setupDirectTriggers();
    console.log("Quiz Countdown Started");
  },

  startTimeTracker() {
    this.startTime = new Date();
    this.quizShown = false;

    // Check every 60 seconds if enough time has passed
    this.timeInterval = setInterval(() => {
      this.checkTimeSpent();
    }, 60000);
  },

  setupEventListeners() {
    // Reset timer on user activity
    const resetTimer = () => {
      if (!this.quizShown) {
        this.startTime = new Date();
      }
    };

    // Events that indicate user activity
    document.addEventListener('click', resetTimer);
    document.addEventListener('scroll', resetTimer);
    document.addEventListener('keypress', resetTimer);
  },

  setupDirectTriggers() {
    // Remove any existing event listeners first
    document.querySelectorAll('.quiz-trigger').forEach(link => {
      // Create a new clone of the element to remove all event listeners
      const newLink = link.cloneNode(true);
      link.parentNode.replaceChild(newLink, link);
    });
    
    // Add new event listeners
    document.querySelectorAll('.quiz-trigger').forEach(link => {
      link.addEventListener('click', (e) => {
        e.preventDefault();
        this.handleQuizTriggerClick();
      });
    });
  },
  
  handleQuizTriggerClick() {
    if (!this.isUserSignedIn()) {
      // Store flag to start quiz after sign in
      sessionStorage.setItem('launch_quiz_after_signin', 'true');
      window.location.href = "/users/sign_in"; // Redirect to sign-in page
    } else {
      this.showStartConfirmation();
    }
  },

  isUserSignedIn() {
    return document.body.dataset.signedIn === "true";
  },  

  showStartConfirmation() {
    // Remove any existing prompt first
    this.removeExistingPrompts();
    
    const promptHTML = `
      <div class="quiz-prompt-overlay">
        <div class="quiz-prompt-container">
          <div class="quiz-content">
            <h3>Start Quiz</h3>
            <p>Are you ready to take a quick knowledge quiz?</p>
          </div>
          <div class="quiz-prompt-buttons">
            <button id="quiz-start-now">Start Quiz Now</button>
            <button id="quiz-cancel">Cancel</button>
          </div>
        </div>
      </div>
    `;

    document.body.insertAdjacentHTML('beforeend', promptHTML);

    document.getElementById('quiz-start-now').addEventListener('click', () => {
      this.removeExistingPrompts();
      this.startQuiz();
    });

    document.getElementById('quiz-cancel').addEventListener('click', () => {
      this.removeExistingPrompts();
    });
  },

  removeExistingPrompts() {
    const promptElement = document.querySelector('.quiz-prompt-overlay');
    if (promptElement) {
      promptElement.remove();
    }
  },

  checkTimeSpent() {
    if (this.quizShown || sessionStorage.getItem('quizPromptShown')) return;

    const currentTime = new Date();
    const timeSpentMs = currentTime - this.startTime;
    const timeSpentMinutes = timeSpentMs / (1000 * 60);

    // Show quiz after 1 minute of activity
    if (timeSpentMinutes >= 1) {
      this.showQuizPrompt();
      sessionStorage.setItem('quizPromptShown', 'true'); // Mark prompt as shown
    }
  },

  showQuizPrompt() {
    this.removeExistingPrompts();
    
    const promptHTML = `
      <div class="quiz-prompt-overlay">
        <div class="quiz-prompt-container">
          <div class="quiz-content">
            <h3>Quick Quiz Time!</h3>
            <p>You've been reading for a while. Take a quick quiz to test your knowledge?</p>
          </div>
          <div class="quiz-prompt-buttons">
            <button id="quiz-accept">Take Quiz</button>
            <button id="quiz-decline">Not Now</button>
          </div>
        </div>
      </div>
    `;

    document.body.insertAdjacentHTML('beforeend', promptHTML);
    this.quizShown = true;

    document.getElementById('quiz-accept').addEventListener('click', () => {
      if (!this.isUserSignedIn()) {
        sessionStorage.setItem('launch_quiz_after_signin', 'true');
        window.location.href = "/users/sign_in"; // Redirect to sign-in page
      } else {
        this.startQuiz();
      }
    });

    document.getElementById('quiz-decline').addEventListener('click', () => {
      this.removeExistingPrompts();
      // Reset the timer to prompt again later
      this.startTime = new Date();
      this.quizShown = false;
    });
  },

  startQuiz() {
    this.removeExistingPrompts();
    const csrfToken = this.getCSRFToken();
    if (!csrfToken) {
      console.error("CSRF token not found. Cannot start quiz.");
      return;
    }
    
    // Show a loader
    const loaderHTML = `
      <div class="quiz-overlay">
        <div class="quiz-container">
          <div class="quiz-loading">
            <h3>Loading Quiz...</h3>
            <div class="loader-spinner"></div>
          </div>
        </div>
      </div>
    `;
    
    document.body.insertAdjacentHTML('beforeend', loaderHTML);
    
    // Make API call to create a new quiz
    fetch('/quizzes', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': csrfToken
      }
    })
      .then(response => response.json())
      .then(data => {
        // Remove the loader
        const loaderElement = document.querySelector('.quiz-overlay');
        if (loaderElement) {
          loaderElement.remove();
        }
        
        this.allQuestions = data.questions;
        this.quizId = data.quiz.id;
        this.userAnswers = {};
        this.currentQuestionIndex = 0;
        this.renderCurrentQuestion();
        this.startTimer();
      })
      .catch(error => {
        console.error('Error starting quiz:', error);
        // Remove the loader and show error message
        const loaderElement = document.querySelector('.quiz-overlay');
        if (loaderElement) {
          loaderElement.innerHTML = `
            <div class="quiz-container">
              <div class="quiz-error">
                <h3>Error Loading Quiz</h3>
                <p>There was a problem loading the quiz. Please try again.</p>
                <button id="close-quiz-error">Close</button>
              </div>
            </div>
          `;
          
          document.getElementById('close-quiz-error').addEventListener('click', () => {
            loaderElement.remove();
          });
        }
      });
  },

  renderCurrentQuestion() {
    const question = this.allQuestions[this.currentQuestionIndex];
    const totalQuestions = this.allQuestions.length;

    // Combine correct and incorrect answers and shuffle them
    const allAnswers = [question.correct_answer, ...question.incorrect_answers];
    this.shuffleArray(allAnswers);

    const answerOptions = allAnswers.map(answer => {
      const isSelected = this.userAnswers[question.id] === answer;
      return `
        <div class="quiz-answer-option">
          <input type="radio" id="q${question.id}_${this.sanitizeForId(answer)}" 
                 name="answer" value="${answer}" ${isSelected ? 'checked' : ''}>
          <label for="q${question.id}_${this.sanitizeForId(answer)}">${answer}</label>
        </div>
      `;
    }).join('');

    const quizHTML = `
      <div class="quiz-overlay">
        <div class="quiz-container">
          <div class="quiz-header">
            <h2>Napoleon News Quiz</h2>
            <div class="quiz-progress">Question ${this.currentQuestionIndex + 1} of ${totalQuestions}</div>
          </div>
          <div class="quiz-content">
            <div class="quiz-question">
              <p>${question.question_text}</p>
              <div class="quiz-answers">
                ${answerOptions}
              </div>
            </div>
          </div>
          <div class="quiz-buttons">
            ${this.currentQuestionIndex > 0 ?
        '<button type="button" id="prev-question">Previous</button>' :
        '<div></div>'}
            ${this.currentQuestionIndex < totalQuestions - 1 ?
        '<button type="button" id="next-question">Next</button>' :
        '<button type="button" id="submit-quiz">Finish Quiz</button>'}
          </div>
        </div>
      </div>
    `;

    const existingTimer = document.getElementById('quiz-timer');

    // Remove existing quiz overlay if present
    const existingOverlay = document.querySelector('.quiz-overlay');
    if (existingOverlay) {
      existingOverlay.remove();
    }

    document.body.insertAdjacentHTML('beforeend', quizHTML);

    // Reattach timer if it existed
    if (existingTimer) {
      document.querySelector(".quiz-container").append(existingTimer);
    }

    // Add event listeners for navigation
    const prevButton = document.getElementById('prev-question');
    if (prevButton) {
      prevButton.addEventListener('click', () => this.navigateToPreviousQuestion());
    }

    const nextButton = document.getElementById('next-question');
    if (nextButton) {
      nextButton.addEventListener('click', () => this.navigateToNextQuestion());
    }

    const submitButton = document.getElementById('submit-quiz');
    if (submitButton) {
      submitButton.addEventListener('click', () => this.submitQuiz());
    }

    // Add event listeners for radio buttons
    document.querySelectorAll('input[name="answer"]').forEach(radio => {
      radio.addEventListener('change', (e) => {
        this.userAnswers[question.id] = e.target.value;
      });
    });
  },

  navigateToPreviousQuestion() {
    // Save current answer if selected
    this.saveCurrentAnswer();

    // Go to previous question
    if (this.currentQuestionIndex > 0) {
      this.currentQuestionIndex--;
      this.renderCurrentQuestion();
    }
  },

  navigateToNextQuestion() {
    // Save current answer if selected
    this.saveCurrentAnswer();

    // Go to next question
    if (this.currentQuestionIndex < this.allQuestions.length - 1) {
      this.currentQuestionIndex++;
      this.renderCurrentQuestion();
    }
  },

  saveCurrentAnswer() {
    const selectedRadio = document.querySelector('input[name="answer"]:checked');
    if (selectedRadio) {
      const questionId = this.allQuestions[this.currentQuestionIndex].id;
      this.userAnswers[questionId] = selectedRadio.value;
    }
  },

  // Helper to sanitize answer text for use in HTML IDs
  sanitizeForId(text) {
    return text.replace(/[^a-z0-9]/gi, '_').toLowerCase();
  },

  // Fisher-Yates shuffle algorithm
  shuffleArray(array) {
    for (let i = array.length - 1; i > 0; i--) {
      const j = Math.floor(Math.random() * (i + 1));
      [array[i], array[j]] = [array[j], array[i]];
    }
    return array;
  },

  submitQuiz(confirmSubmission = true) {
    clearInterval(this.timerInterval); // ⏹️ Stop countdown
    // Save the final answer if selected
    this.saveCurrentAnswer();

    // Check if all questions have been answered
    const answeredQuestions = Object.keys(this.userAnswers).length;
    const totalQuestions = this.allQuestions.length;

    if (answeredQuestions < totalQuestions && confirmSubmission) {
      if (!confirm(`You've only answered ${answeredQuestions} out of ${totalQuestions} questions. Do you want to submit anyway?`)) {
        return;
      }
    }

    const csrfToken = this.getCSRFToken();
    if (!csrfToken) {
      console.error("CSRF token not found. Cannot submit quiz.");
      return;
    }

    // Submit all answers
    fetch(`/quizzes/${this.quizId}`, {
      method: 'PATCH',
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': csrfToken
      },
      body: JSON.stringify({ answers: this.userAnswers })
    })
      .then(response => response.json())
      .then(data => {
        this.showResults(data);
      })
      .catch(error => {
        console.error('Error submitting quiz:', error);
      });
  },

  showResults(data) {
    const quizOverlay = document.querySelector('.quiz-overlay');

    if (quizOverlay) {
      quizOverlay.innerHTML = `
        <div class="quiz-container results">
          <div class="quiz-content">
            <h2>Quiz Results</h2>
            <p>Your score: ${data.score}</p>
            <p>Percentage: ${data.percentage}%</p>
          </div>
          <button id="close-quiz">Close</button>
          ${data.all_correct ? '' : '<button id="retry-quiz">Try Again</button>'}
        </div>
      `;

      document.getElementById('close-quiz').addEventListener('click', () => {
        quizOverlay.remove();
        this.quizShown = false;
        this.startTime = new Date(); // Reset timer
      });
      
      if (!data.all_correct) {
        document.getElementById('retry-quiz').addEventListener('click', () => {
          this.startQuiz();
        });
      }
    }
  },

  retryQuiz() {
    const csrfToken = this.getCSRFToken();
    if (!csrfToken) {
      console.error("CSRF token not found. Cannot retry quiz.");
      return;
    }

    fetch('/quizzes', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': csrfToken
      }
    })  // Create a new quiz
      .then(response => response.json())
      .then(data => {
        console.log("New quiz started:", data);
        this.quizId = data.quiz_id;  // Set new quiz ID
        this.startQuiz();  // Restart quiz
      })
      .catch(error => console.error("Error starting new quiz:", error));
  },

  startTimer() {
    let timeLeft = 180; // 10 seconds for testing - change to 180 for 3 minutes
    const timerElement = document.createElement("div");
    timerElement.id = "quiz-timer";
    timerElement.className = "alert alert-warning text-center";
    timerElement.innerHTML = `Time Left: <span id="time-left">03:00</span>`;

    document.querySelector(".quiz-container").append(timerElement);

    this.timerInterval = setInterval(() => {
      let minutes = Math.floor(timeLeft / 60);
      let seconds = timeLeft % 60;
      document.getElementById("time-left").textContent =
        `${minutes.toString().padStart(2, '0')}:${seconds.toString().padStart(2, '0')}`;

      if (timeLeft === 0) {
        clearInterval(this.timerInterval);
        // Show Time's Up Message
        timerElement.innerHTML = `<strong>⏳ Time's Up! Auto-submitting...</strong>`;

        // Delay auto-submit for 2 seconds so the user sees the message
        setTimeout(() => {
          this.submitQuiz(false); // Auto-submit (no confirmation)
        }, 2000);
      }

      timeLeft--;
    }, 1000);
  },

  getCSRFToken() {
    const metaTag = document.querySelector('meta[name="csrf-token"]');
    if (!metaTag) {
      console.error("CSRF meta tag not found in document!");
      return null;
    }
    return metaTag.content;
  },
  
  // Method to clean up when navigating away
  cleanup() {
    clearInterval(this.timeInterval);
    clearInterval(this.timerInterval);
    this.initialized = false;
  }
};

// Function to handle post-signin quiz launch
const checkForQuizAfterSignin = () => {
  if (sessionStorage.getItem('launch_quiz_after_signin') === 'true') {
    // Only trigger if we're not on the sign-in page
    if (!window.location.pathname.includes('/users/sign_in')) {
      sessionStorage.removeItem('launch_quiz_after_signin');
      setTimeout(() => {
        QuizPopup.showStartConfirmation();
      }, 500); // Short delay to ensure DOM is ready
    }
  }
};

// Clean up before unloading the page
window.addEventListener('beforeunload', () => {
  QuizPopup.cleanup();
});

// For initial page load
document.addEventListener('DOMContentLoaded', () => {
  QuizPopup.init();
  checkForQuizAfterSignin();
});

// For Turbo/Turbolinks navigation
document.addEventListener('turbo:load', () => {
  QuizPopup.cleanup(); // Clean up previous instance
  QuizPopup.init();
  checkForQuizAfterSignin();
});

// For Turbo/Turbolinks before-cache (cleanup)
document.addEventListener('turbo:before-cache', () => {
  QuizPopup.cleanup();
});