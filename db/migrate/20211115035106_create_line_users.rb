class CreateLineUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :line_users do |t|
      t.string :name, null: false
      t.string :user_id, null: false

      t.timestamps
    end
    add_index :line_users, :user_id, unique: true
  end
end
