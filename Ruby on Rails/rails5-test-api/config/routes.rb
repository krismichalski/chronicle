Rails.application.routes.draw do
  devise_scope :user do
    resource :registrations, only: [:create, :update, :destroy], controller: 'devise/registrationss', as: :user_registrations
    resource :password, only: [:create, :update], controller: 'devise/passwords', as: :user_password
  end
  devise_for :users, skip: :all
  use_doorkeeper do
    skip_controllers :applications, :authorized_applications, :authorizations
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
