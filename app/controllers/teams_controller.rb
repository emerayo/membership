# frozen_string_literal: true

class TeamsController < ApplicationController
  # GET /teams
  def index
    @teams = Team.all
  end

  # GET /teams/:id
  def show
    @team = Team.find(params[:id])
  end
end
