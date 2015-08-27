Rails.application.routes.draw do
  root 'summary#index'

  resources 'payments'
  resources 'people', only: [:new, :edit, :create, :update]
  resources 'debts', only: [:edit, :update, :destroy]
end
