# frozen_string_literal: true

class CreateMemberships < ActiveRecord::Migration[7.1]
  def change
    create_table :memberships, id: false do |t|
      t.references :user, foreign_key: { to_table: :users }, type: :uuid, null: false
      t.references :team, foreign_key: { to_table: :teams }, type: :uuid, null: false

      t.timestamps
    end
  end
end
