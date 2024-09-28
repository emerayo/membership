# frozen_string_literal: true

class RolesController < ApplicationController
  # GET /roles
  def index
    @roles = Role.all
  end

  # GET /roles/:id
  def show
    @role = Role.find(params[:id])
  end

  # POST /roles
  def create
    @role = Role.new(role_params)

    if @role.save
      render json: @role, status: :created
    else
      render json: { errors: @role.errors }, status: :unprocessable_entity
    end
  end

  private

  def role_params
    params.require(:role).permit(:name)
  end
end
