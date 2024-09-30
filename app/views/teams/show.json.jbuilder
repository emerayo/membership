# frozen_string_literal: true

json.id @team.id
json.name @team.name
json.teamLeadId @team.team_lead_id

json.teamMemberIds @team.memberships.map(&:user_id)

json.memberships @team.memberships do |membership|
  json.user_id membership.user_id
  json.role_id membership.role_id
  json.role_name membership.role_name
end
