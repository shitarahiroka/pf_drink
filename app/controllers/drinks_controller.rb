class DrinksController < ApplicationController
  skip_before_action :require_login, only: [:new, :create, :suggestion]
  def new
    @drink = Drink.new
  end

  def create
    redirect_to suggestion_drinks_path(drink: drink_params)
  end

  def suggestion
    # フォーム入力値
    study_times = Array(params[:drink][:study_time]).reject(&:empty?)
    mood = params[:drink][:mood]
    calorie_preference = params[:drink][:calorie_preference]
  
    if logged_in? && current_user.respond_to?(:calculate_caffeine_limit)
      # ユーザープロフィールのカフェイン制限値
      caffeine_limit = calculate_caffeine_limit.to_f
    else
      # カフェイン制限値未設定またはログインしていない場合の処理
      caffeine_limit_unlogged = 400
      caffeine_limit = caffeine_limit_unlogged
    end
  
    # 提案結果の初期化
    morning_suggestion = nil
    afternoon_suggestion = nil
    evening_suggestion = nil
  
    # ドリンクの提案
    study_times.each do |study_time|
      if mood == '集中重視'
        if study_time.include?('morning')
          if calorie_preference
            morning_suggestion = Drink.where(mood: '集中重視').where('calories >= 0 AND calories <= 100').sample
          else
            morning_suggestion = Drink.where(mood: '集中重視').sample
          end
          caffeine_limit -= morning_suggestion.caffeine if morning_suggestion
        else
          if calorie_preference
            morning_suggestion = Drink.where(mood: 'エネルギー補給').where('calories >= 0 AND calories <= 100').sample
          else
            morning_suggestion = Drink.where(mood: 'エネルギー補給').sample
          end
            caffeine_limit -= morning_suggestion.caffeine if morning_suggestion
        end

        if study_time.include?('afternoon')
          if calorie_preference
            afternoon_suggestion = Drink.where(mood: '集中重視').where('calories >= 0 AND calories <= 100').sample
          else
            afternoon_suggestion = Drink.where(mood: '集中重視').sample
          end
          caffeine_limit -= afternoon_suggestion.caffeine if afternoon_suggestion
        else
          if calorie_preference
            afternoon_suggestion = Drink.where(mood: 'エネルギー補給').where('calories >= 0 AND calories <= 100').sample
          else
            afternoon_suggestion = Drink.where(mood: 'エネルギー補給').sample
          end
          caffeine_limit -= afternoon_suggestion.caffeine if afternoon_suggestion
        end

        if study_time.include?('evening')
          if calorie_preference
            evening_suggestion = Drink.where(mood: ['集中重視', 'エネルギー補給']).where('calories >= 0 AND calories <= 100').sample
          else
            evening_suggestion = Drink.where(mood: ['集中重視', 'エネルギー補給']).sample
          end
          caffeine_limit -= evening_suggestion.caffeine if evening_suggestion
        else
          if calorie_preference
            evening_suggestion = Drink.where(mood: 'リラックスしながら').where('calories >= 0 AND calories <= 100').sample
          else
            evening_suggestion = Drink.where(mood: 'リラックスしながら').sample
          end
          caffeine_limit -= evening_suggestion.caffeine if evening_suggestion
        end
      elsif mood == 'リラックスしながら'
        if study_time.include?('morning')
          if calorie_preference
            morning_suggestion = Drink.where(mood: '集中重視').where('calories >= 0 AND calories <= 100').sample
          else
            morning_suggestion = Drink.where(mood: '集中重視').sample
          end
          caffeine_limit -= morning_suggestion.caffeine if morning_suggestion
        else
          if calorie_preference
            morning_suggestion = Drink.where(mood: 'リラックスしながら').where('calories >= 0 AND calories <= 100').sample
          else
            morning_suggestion = Drink.where(mood: 'リラックスしながら').sample
          end
          caffeine_limit -= morning_suggestion.caffeine if morning_suggestion
        end
  
        if study_time.include?('afternoon')
          if calorie_preference
            afternoon_suggestion = Drink.where(mood: '集中重視').where('calories >= 0 AND calories <= 100').sample
          else
            afternoon_suggestion = Drink.where(mood: '集中重視').sample
          end
          caffeine_limit -= afternoon_suggestion.caffeine if afternoon_suggestion
        else
          if calorie_preference
            afternoon_suggestion = Drink.where(mood: 'リラックスしながら').where('calories >= 0 AND calories <= 100').sample
          else
            afternoon_suggestion = Drink.where(mood: 'リラックスしながら').sample
          end
          caffeine_limit -= afternoon_suggestion.caffeine if afternoon_suggestion
        end
  
        if study_time.include?('evening')
          evening_suggestion = Drink.where(mood: ['集中重視', 'エネルギー補給']).sample
          caffeine_limit -= evening_suggestion.caffeine if evening_suggestion
        else
          evening_suggestion = Drink.where(mood: 'リラックスしながら').sample
          caffeine_limit -= evening_suggestion.caffeine if evening_suggestion
        end
      elsif mood == 'エネルギー補給'
        if study_time.include?('morning')
          if calorie_preference
            morning_suggestion = Drink.where(mood: 'エネルギー補給').where('calories >= 0 AND calories <= 100').sample
          else
            morning_suggestion = Drink.where(mood: 'エネルギー補給').sample
          end
          caffeine_limit -= morning_suggestion.caffeine if morning_suggestion
        else
          if calorie_preference
            morning_suggestion = Drink.where(mood: '集中重視').where('calories >= 0 AND calories <= 100').sample
          else
            morning_suggestion = Drink.where(mood: '集中重視').sample
          end
          caffeine_limit -= morning_suggestion.caffeine if morning_suggestion
        end
  
        if study_time.include?('afternoon')
          if calorie_preference
            afternoon_suggestion = Drink.where(mood: 'エネルギー補給').where('calories >= 0 AND calories <= 100').sample
          else
            afternoon_suggestion = Drink.where(mood: 'エネルギー補給').sample
          end
          caffeine_limit -= afternoon_suggestion.caffeine if afternoon_suggestion
        else
          if calorie_preference
            afternoon_suggestion = Drink.where(mood: '集中重視').where('calories >= 0 AND calories <= 100').sample
          else
            afternoon_suggestion = Drink.where(mood: '集中重視').sample
          end
          caffeine_limit -= afternoon_suggestion.caffeine if afternoon_suggestion
        end
  
        if study_time.include?('evening')
          if calorie_preference
            evening_suggestion = Drink.where(mood: ['集中重視', 'エネルギー補給']).where('calories >= 0 AND calories <= 100').sample
          else
            evening_suggestion = Drink.where(mood: ['集中重視', 'エネルギー補給']).sample
          end
          caffeine_limit -= evening_suggestion.caffeine if evening_suggestion
        else
          if calorie_preference
            evening_suggestion = Drink.where(mood: 'リラックスしながら').where('calories >= 0 AND calories <= 100').sample
          else
            evening_suggestion = Drink.where(mood: 'リラックスしながら').sample
          end
          caffeine_limit -= evening_suggestion.caffeine if evening_suggestion
        end
      end
    end
  
    # カフェインの総摂取量を計算
    caffeine_total = [morning_suggestion, afternoon_suggestion, evening_suggestion].compact.sum(&:caffeine)
  
    # カフェイン制限を超えている場合は再度ドリンクを選び直す
    if caffeine_limit < 0
      return suggestion
    end
  
    # インスタンス変数に結果を格納する
    @morning_suggestion = morning_suggestion
    @afternoon_suggestion = afternoon_suggestion
    @evening_suggestion = evening_suggestion
    @caffeine_total = caffeine_total
  
    # 提案結果を表示するビューへリダイレクトする
    render 'result'
  end

  private

  def drink_params
    params.require(:drink).permit(:mood, :calorie_preference, study_time: [])
  end

  def calculate_caffeine_limit
    profile_controller = ProfilesController.new
    user = current_user
    profile_controller.send(:calculate_caffeine_limit, user)
  end
end
