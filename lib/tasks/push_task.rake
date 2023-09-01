namespace :push_task do
  desc "LINEBOT：朝のドリンク記録通知と診断フォームリンク"
  task :push_line_morning_message_drink_record => :environment do
    client = Line::Bot::Client.new { |config|
      config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
      config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
    }

    today = Date.current
    users_to_notify = User.joins(:drink_records).where(drink_records: { date: today.beginning_of_day..today.end_of_day })

    users_to_notify.each do |user|
      morning_drink_records = user.drink_records.where(date: today.beginning_of_day..today.end_of_day)

      morning_drink_records.each do |morning_drink_record|
        morning_drink = Drink.find_by(id: morning_drink_record.morning_suggestion)

        if morning_drink.present?
          message = {
            type: 'text',
            text: "おはようございます！今日の朝のドリンク記録は以下です：\n" +
                  "朝: #{morning_drink&.name} (#{morning_drink&.caffeine}mg)"
          }
        end

        response = client.push_message(user.line_user_id, message)
        p response
      end
    end
  end

  desc "LINEBOT：昼のドリンク記録通知と診断フォームリンク"
  task :push_line_afternoon_message_drink_record => :environment do
    client = Line::Bot::Client.new { |config|
      config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
      config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
    }

    today = Date.current
    users_to_notify = User.joins(:drink_records).where(drink_records: { date: today.beginning_of_day..today.end_of_day })

    users_to_notify.each do |user|
      afternoon_drink_records = user.drink_records.where(date: today.beginning_of_day..today.end_of_day)

      afternoon_drink_records.each do |afternoon_drink_record|
        afternoon_drink = Drink.find_by(id: afternoon_drink_record.afternoon_suggestion)

        if afternoon_drink_record.present?
          message = {
            type: 'text',
            text: "こんにちは！今日の昼のドリンク記録は以下です：\n" +
                  "昼: #{afternoon_drink&.name} (#{afternoon_drink&.caffeine}mg)"
          }
        end

        response = client.push_message(user.line_user_id, message)
        p response
      end
    end
  end

  desc "LINEBOT：夜のドリンク記録通知と診断フォームリンク"
  task :push_line_evening_message_drink_record => :environment do
    client = Line::Bot::Client.new { |config|
      config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
      config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
    }

    today = Date.current
    users_to_notify = User.joins(:drink_records).where(drink_records: { date: today.beginning_of_day..today.end_of_day })

    users_to_notify.each do |user|
      evening_drink_records = user.drink_records.where(date: today.beginning_of_day..today.end_of_day)

      evening_drink_records.each do |evening_drink_record|
        evening_drink = Drink.find_by(id: evening_drink_record.evening_suggestion)

        if evening_drink_record.present?
          message = {
            type: 'text',
            text: "こんばんは！今日の夜のドリンク記録は以下です：\n" +
                  "夜: #{evening_drink&.name} (#{evening_drink&.caffeine}mg)"
          }
        end

        response = client.push_message(user.line_user_id, message)
        p response
      end
    end
  end
end