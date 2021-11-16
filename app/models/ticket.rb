require 'giftee/gajoen'

class Ticket < ApplicationRecord
  belongs_to :line_user
  belongs_to :coupon_setting

  def self.create_ticket(brand_id = 145, item_id, request_code, coupon_setting_id, line_user_id)
    client = Giftee::Gajoen::Client.new({ domain: ENV["GAJOEN_DOMAIN"], token: ENV["GAJOEN_TOKEN"] })
    coupon_hash = client.post({ brand_id: brand_id, item_id: item_id, request_code: request_code })

    ticket = Ticket.new(coupon_hash.slice('url', 'item_id', 'status'))

    ticket.coupon_setting = CouponSetting.find(coupon_setting_id)
    ticket.line_user = LineUser.find(line_user_id)

    %w[issued_at exchanged_at disabled_at].each do |at|
      ticket.send("#{at}=", Time.at(coupon_hash[at])) unless coupon_hash[at].nil?
    end

    ticket.save
    ticket
  end
end
