# frozen_string_literal: true

json.array! @teams do |team|
  json.id team.id
  json.name team.name
end
