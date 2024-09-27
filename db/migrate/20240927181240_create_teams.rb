# frozen_string_literal: true

class CreateTeams < ActiveRecord::Migration[7.1]
  def change
    create_table :teams, id: :uuid do |t|
      t.references :team_lead, foreign_key: { to_table: :users }, type: :uuid, null: false
      t.string :name, null: false

      t.timestamps
    end
  end
end
