# frozen_string_literal: true

class UsersController < ApplicationController
  # GET /users
  def index
    @users = User.cached_relation
  end

  # GET /users/:id
  def show
    @user = User.includes(:teams, memberships: :role).find(params[:id])
  end
end
