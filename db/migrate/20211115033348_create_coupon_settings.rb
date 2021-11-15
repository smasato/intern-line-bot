class
CreateCouponSettings < ActiveRecord::Migration[6.0]
  def change
    create_table :coupon_settings do |t|
      t.integer :item_id, null: false
      t.string :status, null: false
      t.string :name, null: false
      t.string :message, null: false
      t.binary :thumbnail, null: false

      t.timestamps
    end

    create_table :coupon_setting_follow_options do |t|
      t.references :coupon_setting, foreign_key: true

      t.timestamps
    end

    create_table :coupon_setting_duration_options do |t|
      t.references :coupon_setting, foreign_key: true
      t.datetime :start_at, null: false
      t.datetime :end_at, null: false

      t.timestamps
    end
  end
end
