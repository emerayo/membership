# frozen_string_literal: true

module Roles
  class MembershipsController < ApplicationController
    # GET /roles/:role_id/memberships
    def index
      # Using this allows for one query and
      # always returns the Role's data even if no Membership exists
      @role = Role.includes(:memberships).find(params[:role_id])
      @memberships = @role.memberships
    end
  end
end
