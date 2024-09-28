# frozen_string_literal: true

class ChangeMemberships < ActiveRecord::Migration[7.1]
  def change
    add_reference :memberships, :role, null: false, type: :uuid, foreign_key: { to_table: :roles }
    add_index :memberships, %i[user_id team_id], unique: true
  end
end
