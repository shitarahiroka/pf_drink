class DrinksController < ApplicationController
  def new
    @drink = Drink.new
  end

  def create
    redirect_to suggestion_drinks_path(drink: drink_params)
  end

  def suggestion
    # フォーム入力値
    study_time = params[:study_time]
    mood = params[:mood]
    calorie_preference = params[:calorie_preference]
    # ユーザープロフィールのカフェイン制限値
    caffeine_limit = calculate_caffeine_limit.to_f

    # ドリンクデータベースからドリンク情報を取得
    drinks_data = Drink.all
    # binding.break

    morning_drinks = []
    afternoon_drinks = []
    evening_drinks = []

    # 学習時間帯に応じてドリンクを分類する
    drinks_data.each do |drink|
      if drink[:mood] == mood
        if study_time.present? && study_time.include?('morning')
          morning_drinks << drink
        end
        if study_time.present? && study_time.include?('afternoon')
          afternoon_drinks << drink
        end
        if study_time.present? && study_time.include?('evening')
          evening_drinks << drink
        end
      elsif !study_time.present? || (!study_time.include?('morning') || !study_time.include?('afternoon') || !study_time.include?('evening'))
        if drink[:caffeine] <= 30.0 || drink[:mood] == 'リラックスしながら'
          morning_drinks << drink
          afternoon_drinks << drink
          evening_drinks << drink
        end
      end
    end

    # カロリーが制限値以下のドリンクを選択する
    if calorie_preference
      morning_drinks = morning_drinks.select { |drink| drink[:calories] <= 10 }
      afternoon_drinks = afternoon_drinks.select { |drink| drink[:calories] <= 10 }
      evening_drinks = evening_drinks.select { |drink| drink[:calories] <= 10 }
    end

    # カフェイン総摂取量を計算する
    caffeine_total = 0.0
    morning_suggestion = morning_drinks.sample(1)
    afternoon_suggestion = (afternoon_drinks - morning_suggestion).sample(1)
    evening_suggestion = (evening_drinks - morning_suggestion - afternoon_suggestion).sample(1)

    if morning_suggestion.first
      caffeine_total += morning_suggestion.first[:caffeine].to_f
      morning_suggestion = [] if caffeine_total > caffeine_limit
    end

    if afternoon_suggestion.first
      caffeine_total += afternoon_suggestion.first[:caffeine].to_f
      afternoon_suggestion = [] if caffeine_total > caffeine_limit
    end

    if evening_suggestion.first
      caffeine_total += evening_suggestion.first[:caffeine].to_f
      evening_suggestion = [] if caffeine_total > caffeine_limit
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
    params.require(:drink).permit(:mood, :study_time, :calorie_preference)
  end

  def calculate_caffeine_limit
    profile_controller = ProfilesController.new
    user = current_user
    profile_controller.send(:calculate_caffeine_limit, user)
  end
end
