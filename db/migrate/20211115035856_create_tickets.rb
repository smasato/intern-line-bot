class CreateTickets < ActiveRecord::Migration[6.0]
  def change
    create_table :tickets do |t|
      t.integer :item_id, null: false
      t.string :url, null: false
      t.string :status, null: false
      t.datetime :issued_at, null: false
      t.datetime :exchanged_at, null: true
      t.datetime :disabled_at, null: true
      t.references :line_user, foreign_key: true
      t.references :coupon_setting, foreign_key: true

      t.timestamps
    end
    add_index :tickets, :url, unique: true
  end
end
