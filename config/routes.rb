# frozen_string_literal: true

Rails.application.routes.draw do
  resources :roles, only: %i[create index show] do
    collection do
      get 'search'
    end

    resources :memberships, only: :index, module: 'roles'
  end

  resources :teams, only: %i[index show] do
    resources :memberships, only: %i[create update show], module: 'teams'
  end

  resources :users, only: %i[index show]
end
