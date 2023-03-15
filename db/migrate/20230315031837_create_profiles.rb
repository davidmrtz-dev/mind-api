class CreateProfiles < ActiveRecord::Migration[6.1]
  def change
    create_table :profiles do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :english_level
      t.text :technical_knowledge
      t.string :cv
      t.timestamps
    end
  end
end
