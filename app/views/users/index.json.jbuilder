# frozen_string_literal: true

json.array! @users do |user|
  json.id user.id
  json.displayName user.display_name
end
