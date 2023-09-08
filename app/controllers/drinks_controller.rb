class DrinksController < ApplicationController
  skip_before_action :require_login, only: %i[new create suggestion]
  def new
    @drink = Drink.new
  end

  def create
    redirect_to suggestion_drinks_path(drink: drink_params)
  end

  def suggestion
    # フォーム入力値
    study_time = Array(params[:drink][:study_time]).reject(&:empty?)
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
    case mood
    when '集中重視'
      morning_mood = study_time.include?('morning') ? '集中重視' : 'エネルギー補給'
      afternoon_mood = study_time.include?('afternoon') ? '集中重視' : 'エネルギー補給'
      evening_moods = study_time.include?('evening') ? %w[集中重視 エネルギー補給] : ['リラックスしながら']

    when 'リラックスしながら'
      morning_mood = study_time.include?('morning') ? '集中重視' : 'リラックスしながら'
      afternoon_mood = study_time.include?('afternoon') ? '集中重視' : 'リラックスしながら'
      evening_moods = study_time.include?('evening') ? %w[集中重視 エネルギー補給] : ['リラックスしながら']

    when 'エネルギー補給'
      morning_mood = study_time.include?('morning') ? 'エネルギー補給' : '集中重視'
      afternoon_mood = study_time.include?('afternoon') ? 'エネルギー補給' : '集中重視'
      evening_moods = study_time.include?('evening') ? %w[集中重視 エネルギー補給] : ['リラックスしながら']
    end

    morning_candidates = Drink.where(mood: morning_mood)
    afternoon_candidates = Drink.where(mood: afternoon_mood)
    evening_candidates = Drink.where(mood: evening_moods)

    morning_candidates = morning_candidates.where('calories >= 0 AND calories <= 100') if calorie_preference
    if afternoon_suggestion || evening_suggestion
      morning_candidates = morning_candidates.where.not(id: [afternoon_suggestion,
                                                             evening_suggestion].compact.map(&:id))
    end
    morning_suggestion = morning_candidates.sample
    caffeine_limit -= morning_suggestion.caffeine if morning_suggestion

    afternoon_candidates = afternoon_candidates.where('calories >= 0 AND calories <= 100') if calorie_preference
    if morning_suggestion || evening_suggestion
      afternoon_candidates = afternoon_candidates.where.not(id: [morning_suggestion,
                                                                 evening_suggestion].compact.map(&:id))
    end
    afternoon_suggestion = afternoon_candidates.sample
    caffeine_limit -= afternoon_suggestion.caffeine if afternoon_suggestion

    evening_candidates = evening_candidates.where('calories >= 0 AND calories <= 100') if calorie_preference
    if morning_suggestion || afternoon_suggestion
      evening_candidates = evening_candidates.where.not(id: [morning_suggestion,
                                                             afternoon_suggestion].compact.map(&:id))
    end
    evening_suggestion = evening_candidates.sample
    caffeine_limit -= evening_suggestion.caffeine if evening_suggestion

    # カフェインの総摂取量を計算
    caffeine_total = [morning_suggestion, afternoon_suggestion, evening_suggestion].compact.sum(&:caffeine)

    # カフェイン制限を超えている場合は再度ドリンクを選び直す
    return suggestion if caffeine_limit.negative?

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
    current_user.calculate_caffeine_limit
  end
end
