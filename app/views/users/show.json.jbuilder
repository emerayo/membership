# frozen_string_literal: true

json.id @user.id
json.displayName @user.display_name
json.firstName @user.first_name
json.lastName @user.last_name
json.avatarUrl @user.avatar_url
json.location @user.location

json.memberships @user.memberships do |membership|
  json.team_id membership.team_id
  json.role_id membership.role_id
  json.role_name membership.role_name
end

json.leading_teams @user.leading_teams do |team|
  json.id team.id
  json.name team.name
end
