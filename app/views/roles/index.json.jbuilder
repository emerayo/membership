# frozen_string_literal: true

json.array! @roles do |role|
  json.id role.id
  json.name role.name
end
