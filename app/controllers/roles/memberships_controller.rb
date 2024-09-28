# frozen_string_literal: true

module Roles
  class MembershipsController < ApplicationController
    # GET /roles/:role_id/memberships
    def index
      @role = Role.includes(:memberships).find(params[:role_id])
      @memberships = @role.memberships
    end
  end
end
