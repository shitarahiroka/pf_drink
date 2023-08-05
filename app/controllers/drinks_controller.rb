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
    caffeine_total = 0

    # ドリンクの提案
    if mood == '集中重視'
      if study_time.include?('morning')
        # 選択された朝のドリンク候補を取得
        morning_candidates = Drink.where(mood: '集中重視')
        morning_candidates = morning_candidates.where('calories >= 0 AND calories <= 100') if calorie_preference
      else
        # 選択された朝のドリンク候補を取得
        morning_candidates = Drink.where(mood: 'エネルギー補給')
        morning_candidates = morning_candidates.where('calories >= 0 AND calories <= 100') if calorie_preference
      end
      # すでに選ばれたドリンクと重複しないように選択
      morning_candidates = morning_candidates.where.not(id: [afternoon_suggestion, evening_suggestion].compact.map(&:id)) if afternoon_suggestion || evening_suggestion
      morning_suggestion = morning_candidates.sample

      caffeine_limit -= morning_suggestion.caffeine if morning_suggestion

      if study_time.include?('afternoon')
        afternoon_candidates = Drink.where(mood: '集中重視')
        afternoon_candidates = afternoon_candidates.where('calories >= 0 AND calories <= 100') if calorie_preference
      else
        afternoon_candidates = Drink.where(mood: 'エネルギー補給')
        afternoon_candidates = afternoon_candidates.where('calories >= 0 AND calories <= 100') if calorie_preference
      end
      afternoon_candidates = afternoon_candidates.where.not(id: [morning_suggestion, evening_suggestion].compact.map(&:id)) if morning_suggestion || evening_suggestion
      afternoon_suggestion = afternoon_candidates.sample

      caffeine_limit -= afternoon_suggestion.caffeine if afternoon_suggestion

      if study_time.include?('evening')
        evening_candidates = Drink.where(mood: ['集中重視', 'エネルギー補給'])
        evening_candidates = evening_candidates.where('calories >= 0 AND calories <= 100') if calorie_preference
      else
        evening_candidates = Drink.where(mood: ['リラックスしながら'])
        evening_candidates = evening_candidates.where('calories >= 0 AND calories <= 100') if calorie_preference
      end
      evening_candidates = evening_candidates.where.not(id: [morning_suggestion, afternoon_suggestion].compact.map(&:id)) if morning_suggestion || afternoon_suggestion
      evening_suggestion = evening_candidates.sample

      caffeine_limit -= evening_suggestion.caffeine if evening_suggestion

    elsif mood == 'リラックスしながら'
      if study_time.include?('morning')
        morning_candidates = Drink.where(mood: '集中重視')
        morning_candidates = morning_candidates.where('calories >= 0 AND calories <= 100') if calorie_preference
      else
        morning_candidates = Drink.where(mood: 'リラックスしながら')
        morning_candidates = morning_candidates.where('calories >= 0 AND calories <= 100') if calorie_preference
      end
      morning_candidates = morning_candidates.where.not(id: [afternoon_suggestion, evening_suggestion].compact.map(&:id)) if afternoon_suggestion || evening_suggestion
      morning_suggestion = morning_candidates.sample

      caffeine_limit -= morning_suggestion.caffeine if morning_suggestion

      if study_time.include?('afternoon')
        afternoon_candidates = Drink.where(mood: '集中重視')
        afternoon_candidates = afternoon_candidates.where('calories >= 0 AND calories <= 100') if calorie_preference
      else
        afternoon_candidates = Drink.where(mood: 'リラックスしながら')
        afternoon_candidates = afternoon_candidates.where('calories >= 0 AND calories <= 100') if calorie_preference
      end
      afternoon_candidates = afternoon_candidates.where.not(id: [morning_suggestion, evening_suggestion].compact.map(&:id)) if morning_suggestion || evening_suggestion
      afternoon_suggestion = afternoon_candidates.sample

      caffeine_limit -= afternoon_suggestion.caffeine if afternoon_suggestion

      if study_time.include?('evening')
        evening_candidates = Drink.where(mood: ['集中重視', 'エネルギー補給'])
        evening_candidates = evening_candidates.where('calories >= 0 AND calories <= 100') if calorie_preference
      else
        evening_candidates = Drink.where(mood: ['リラックスしながら'])
        evening_candidates = evening_candidates.where('calories >= 0 AND calories <= 100') if calorie_preference
      end
      evening_candidates = evening_candidates.where.not(id: [morning_suggestion, afternoon_suggestion].compact.map(&:id)) if morning_suggestion || afternoon_suggestion
      evening_suggestion = evening_candidates.sample

      caffeine_limit -= evening_suggestion.caffeine if evening_suggestion

    elsif mood == 'エネルギー補給'
      if study_time.include?('morning')
        morning_candidates = Drink.where(mood: 'エネルギー補給')
        morning_candidates = morning_candidates.where('calories >= 0 AND calories <= 100') if calorie_preference
      else
        morning_candidates = Drink.where(mood: '集中重視')
        morning_candidates = morning_candidates.where('calories >= 0 AND calories <= 100') if calorie_preference
      end
      morning_candidates = morning_candidates.where.not(id: [afternoon_suggestion, evening_suggestion].compact.map(&:id)) if afternoon_suggestion || evening_suggestion
      morning_suggestion = morning_candidates.sample

      caffeine_limit -= morning_suggestion.caffeine if morning_suggestion

      if study_time.include?('afternoon')
        afternoon_candidates = Drink.where(mood: 'エネルギー補給')
        afternoon_candidates = afternoon_candidates.where('calories >= 0 AND calories <= 100') if calorie_preference
      else
        afternoon_candidates = Drink.where(mood: '集中重視')
        afternoon_candidates = afternoon_candidates.where('calories >= 0 AND calories <= 100') if calorie_preference
      end
      afternoon_candidates = afternoon_candidates.where.not(id: [morning_suggestion, evening_suggestion].compact.map(&:id)) if morning_suggestion || evening_suggestion
      afternoon_suggestion = afternoon_candidates.sample

      caffeine_limit -= afternoon_suggestion.caffeine if afternoon_suggestion

      if study_time.include?('evening')
        evening_candidates = Drink.where(mood: ['集中重視', 'エネルギー補給'])
        evening_candidates = evening_candidates.where('calories >= 0 AND calories <= 100') if calorie_preference
      else
        evening_candidates = Drink.where(mood: ['リラックスしながら'])
        evening_candidates = evening_candidates.where('calories >= 0 AND calories <= 100') if calorie_preference
      end
      evening_candidates = evening_candidates.where.not(id: [morning_suggestion, afternoon_suggestion].compact.map(&:id)) if morning_suggestion || afternoon_suggestion
      evening_suggestion = evening_candidates.sample

      caffeine_limit -= evening_suggestion.caffeine if evening_suggestion

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
    current_user.calculate_caffeine_limit
  end
end
