Rails.application.routes.draw do
  resources :stocks, only: %i[index create update destroy]
end
