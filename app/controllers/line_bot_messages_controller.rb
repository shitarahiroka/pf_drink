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

  def account_link_event
    event = params["events"][0]
    line_user_id = event["source"]["userId"]
    if event["type"] == "accountLink" && event["link"]["result"] == "ok"
      # アカウント連携成功時の処理
      user = User.find_by(line_user_id: line_user_id)
      if user
        user.update(line_user_id: nil) # line_user_idを連携成功後はnilに更新するなどの処理
        # 他の必要な処理を追加
      end
    end
  end

  private

  def handle_text_message(event)
    text = event.message['text']

    if text == "今日のドリンク記録"
      send_drink_record_notification(event)
    else
      send_default_reply(event)
    end
  end

  def send_drink_record_notification(event)
    user = User.find_by(line_user_id: event['source']['userId'])
    today = Date.current
    drink_records = user.drink_records.where(date: today.beginning_of_day..today.end_of_day)

    if drink_records.present?
      total_caffeine = drink_records.sum(:caffeine_total)

      drink_records_messages = drink_records.map do |record|
        morning_drink = Drink.find_by(id: record.morning_suggestion)
        afternoon_drink = Drink.find_by(id: record.afternoon_suggestion)
        evening_drink = Drink.find_by(id: record.evening_suggestion)

        "朝: #{morning_drink&.name} (#{morning_drink&.caffeine}mg)\n" +
        "昼: #{afternoon_drink&.name} (#{afternoon_drink&.caffeine}mg)\n" +
        "夜: #{evening_drink&.name} (#{evening_drink&.caffeine}mg)"
      end

      total_message = "合計カフェイン摂取量: #{total_caffeine}mg"

      message = {
        type: 'text',
        text: "今日のドリンク記録は以下です：\n#{drink_records_messages.join("\n\n")}\n\n#{total_message}"
      }
    else
      message = {
        type: 'text',
        text: "今日のドリンク記録はありません。\nドリンク診断を行うにはメニューからアプリを開いてください。"
      }
    end

    client.reply_message(event['replyToken'], message)
  end

  def send_default_reply(event)
    message = {
      type: 'text',
      text: "ごめんなさい。メッセージの返信はできません。"
    }
    client.reply_message(event['replyToken'], message)
  end
end