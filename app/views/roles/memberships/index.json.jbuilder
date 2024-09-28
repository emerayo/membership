# frozen_string_literal: true

json.id @role.id
json.name @role.name

json.memberships @memberships, :team_id, :user_id
