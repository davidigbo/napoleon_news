Rails.application.routes.draw do
  devise_for :users

  resources :categories, only: [:index, :show] do
    member do
      get :articles
    end
  end

  resources :articles, only: [:new, :edit, :index, :show, :create, :update, :destroy], param: :slug do
    resources :comments, only: [:create, :destroy]
    member do
      patch :update_status
    end

    collection do
      resources :review_article, only: :show, param: :slug
      # get 'search'
    end
  end

  resources :contests, only: [:index] do
    resources :contestants, only: [:index, :show, :new, :create, :edit, :update, :destroy], param: :slug do
      resources :votes, only: [:create]
      resources :comments, only: [:create, :destroy]
    end
    resources :leaderboards, only: [:index]
  end

  resources :search, only: [:index]

  
  
  root to: "home#index"

  resources :users, only: [:index, :update] do
    resources :authored_articles, only: :index
    resources :admin, only: :index do
      collection do
        resources :manage_articles, only: :index do
          collection do
            get :draft
            get :under_review
            get :published
            get :approved
          end
        end
        resources :analytics, only: :index
      end
    end
    member do
      patch :update_role
    end
  end

  post "/contact_us", to: "contacts#create"

  resources :quizzes, only: [:show, :create, :update]
  post '/quizzes/check_time', to: 'quizzes#check_time'
end
