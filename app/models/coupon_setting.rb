class CouponSetting < ApplicationRecord
  has_one :follow_option

  scope :enabled, -> do
    where(status: 'enabled')
  end
  scope :follow_option, -> do
    joins(:follow_option)
  end
end
