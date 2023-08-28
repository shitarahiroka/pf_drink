namespace :push_task do
  desc "LINEBOT：ドリンク記録通知と診断フォームリンク"
  task :push_line_message_drink_record => :environment do
    client = Line::Bot::Client.new { |config|
      config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
      config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
    }

    today = Date.current
    users_to_notify = User.joins(:drink_records).where(drink_records: { date: today.beginning_of_day..today.end_of_day })

    users_to_notify.each do |user|
      drink_records = user.drink_records.where(date: today.beginning_of_day..today.end_of_day)

      if drink_records.present?
        total_caffeine = drink_records.sum(:caffeine_total) # カフェイン摂取量の合計

        # ドリンク記録がある場合の通知
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
        # ドリンク記録がない場合の通知
        message = {
          type: 'text',
          text: "今日のドリンク記録はありません。ドリンク診断を行うには以下のリンクをクリックしてください。\nhttp://example.com/drink_diagnosis"
        }
      end

      response = client.push_message(user.line_user_id, message)
      p response
    end
  end
end