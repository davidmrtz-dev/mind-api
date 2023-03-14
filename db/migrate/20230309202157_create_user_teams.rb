class CreateUserTeams < ActiveRecord::Migration[6.1]
  def change
    create_table :user_teams do |t|
      t.references :user, null: false, foreign_key: true
      t.references :team, null: false, foreign_key: true
      t.date :start_at
      t.date :end_at
      t.integer :status

      t.timestamps
    end
  end
end
