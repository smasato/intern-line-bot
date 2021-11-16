require 'line/bot'

class WebhookController < ApplicationController
  protect_from_forgery except: [:callback] # CSRF対策無効化

  def client
    @client ||= Line::Bot::Client.new { |config|
      config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
      config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
    }
  end

  def callback
    body = request.body.read

    signature = request.env['HTTP_X_LINE_SIGNATURE']
    unless client.validate_signature(body, signature)
      head 470
    end

    events = client.parse_events_from(body)
    events.each { |event|
      case event
      when Line::Bot::Event::Follow
        user = LineUser.find_by_user_id(event['source']["userId"]) || LineUser.create(user_id: event['source']["userId"],
                                                                                      name: JSON.parse(client.get_profile(event['source']["userId"]).body)['displayName'])
        settings = CouponSetting.follow_option.enabled
        if settings
          settings.each do |s|
            next if Ticket.where(line_user_id: user.id, coupon_setting_id: s.id).present?

            ticket = Ticket.create_ticket(item_id = s.item_id, request_code = user.user_id + s.id.to_s,
                                          coupon_setting_id = s.id, line_user_id = user.id)
            logger.debug ticket
            message = {
              type: 'template',
              altText: s.message,
              template: {
                type: "buttons",
                text: s.message,
                actions: [
                  {
                    type: 'uri',
                    label: 'クーポンを使う',
                    uri: ticket.url
                  }
                ]
              }
            }
            logger.debug 'message ' + message.to_s
            res = client.push_message(user.user_id, message)
            logger.debug 'responce code ' + res.code
            logger.debug 'responce body ' + res.body
            logger.debug 'responce message ' + res.message.to_s
          end
        end
      when Line::Bot::Event::Message
        case event.type
        when Line::Bot::Event::MessageType::Text
          message = {
            type: 'text',
            text: event.message['text']
          }
          client.reply_message(event['replyToken'], message)
        when Line::Bot::Event::MessageType::Image, Line::Bot::Event::MessageType::Video
          response = client.get_message_content(event.message['id'])
          tf = Tempfile.open("content")
          tf.write(response.body)
        end
      end
    }
    head :ok
  end
end
