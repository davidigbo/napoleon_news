Rails.application.routes.draw do
  devise_for :users

  resources :categories, only: [:index, :show] do
    member do
      get :articles
    end
  end

  resources :articles, only: [:new, :edit, :index, :show, :create, :update, :destroy], param: :slug do
    resources :comments
    member do
      patch :update_status
    end

    collection do
      resources :review_article, only: :show, param: :slug
    end
  end

  resources :contestants, only: [:index, :show, :edit, :update, :destroy], param: :slug do
  end

  resources :leaderboards, only: [:index]
  
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
      end
    end
    member do
      patch :update_role
    end
  end
end
