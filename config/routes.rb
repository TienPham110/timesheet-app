Rails.application.routes.draw do
  resources :timesheet_entries, only: [:index, :new, :create]
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "timesheet_entries#index"
end
