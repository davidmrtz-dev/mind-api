class CreateAccounts < ActiveRecord::Migration[6.1]
  def change
    create_table :accounts do |t|
      t.string :client_name, null: false
      t.string :manager_name, null: false
      t.string :name, null: false

      t.timestamps
    end
  end
end
