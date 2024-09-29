# frozen_string_literal: true

module Teams
  class MembershipsController < ApplicationController
    # GET /teams/:team_id/memberships/:id
    def show
      @membership = Membership.find_by!(team_id: params[:team_id], user_id: params[:id])
      render json: @membership
    end

    # POST /teams/:team_id/memberships
    def create
      @team = Team.find(params[:team_id])
      @membership = Membership.new(membership_params)

      if @membership.save
        render json: @membership, status: :created
      else
        render json: { errors: @membership.errors }, status: :unprocessable_entity
      end
    end

    # PATCH /teams/:team_id/memberships/:id
    def update
      @membership = Membership.find_by!(team_id: params[:team_id], user_id: params[:id])

      if @membership.update(update_params)
        render json: @membership
      else
        render json: { errors: @membership.errors }, status: :unprocessable_entity
      end
    end

    private

    def membership_params
      params.require(:membership).permit(:role_id, :user_id).merge(team_id: params[:team_id])
    end

    def update_params
      params.require(:membership).permit(:role_id)
    end
  end
end
