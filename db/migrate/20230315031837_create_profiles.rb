class CreateProfiles < ActiveRecord::Migration[6.1]
  def change
    create_table :profiles do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :english_level, null: false, default: 0
      t.text :technical_knowledge, null: false
      t.string :cv
      t.timestamps
    end
  end
end
