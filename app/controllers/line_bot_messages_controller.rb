class LineBotMessagesController < ApplicationController
  skip_before_action :require_login
  protect_from_forgery except: [:callback]  # CSRF対策の例外設定
  require 'line/bot'

  def client
    @client ||= Line::Bot::Client.new { |config|
      config.channel_id = ENV["LINE_CHANNEL_ID"]
      config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
      config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
    }
  end

  def callback
    body = request.body.read

    signature = request.env['HTTP_X_LINE_SIGNATURE']
    unless client.validate_signature(body, signature)
      error 400 do 'Bad Request' end
    end

    events = client.parse_events_from(body)
    events.each do |event|
      case event
      when Line::Bot::Event::Message
        case event.type
        when Line::Bot::Event::MessageType::Text
          handle_text_message(event)
        end
      end
    end

    render plain: 'OK', status: :ok
  end

  private

  def handle_text_message(event)
    text = event.message['text']
    reply_message(event, text)
  end

  def reply_message(event, text)
    message = {
      type: 'text',
      text: text
    }
    client.reply_message(event['replyToken'], message)
  end
end