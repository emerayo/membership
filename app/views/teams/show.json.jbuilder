# frozen_string_literal: true

json.id @team.id
json.name @team.name
json.teamLeadId @team.team_lead_id

json.teamMemberIds @team.memberships.map(&:user_id)
