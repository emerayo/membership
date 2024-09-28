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
end
