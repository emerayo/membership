# frozen_string_literal: true

json.array! @roles do |role|
  json.id role.id
  json.name role.name

  json.memberships role.memberships do |membership|
    json.team_id membership.team_id
    json.user_id membership.user_id
  end
end
