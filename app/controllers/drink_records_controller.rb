class DrinkRecordsController < ApplicationController
  def create
    existing_record = DrinkRecord.find_by(user_id: current_user.id, date: params[:date])
    if existing_record.present?
      redirect_to mypage_calendar_path, danger: t('.fail')
    else
      @drink_record = DrinkRecord.new(drink_record_params)
      if @drink_record.save
        redirect_to mypage_calendar_path, success: t('.success')
      else
        redirect_to mypage_calendar_path
      end
    end
  end

  def show
    @drink_record = DrinkRecord.find(params[:id])
  end

  def edit
    @drink_record = DrinkRecord.find(params[:id])
  end

  def update
    @drink_record = DrinkRecord.find(params[:id])
    caffeine_limit = current_user.calculate_caffeine_limit.to_f

    # ドリンクの更新を試みる
    if @drink_record.update(drink_record_params)
      # 各摂取量を取得してカフェイン総摂取量を計算
      morning_suggestion = @drink_record.morning_suggestion.caffeine.to_f
      afternoon_suggestion = @drink_record.afternoon_suggestion.caffeine.to_f
      evening_suggestion = @drink_record.evening_suggestion.caffeine.to_f
      caffeine_total = morning_suggestion + afternoon_suggestion + evening_suggestion

      # カフェイン総摂取量を更新
      @drink_record.update(caffeine_total:)

      if caffeine_total > caffeine_limit
        # カフェイン制限を超える場合は更新をキャンセルし、エラーメッセージを表示
        flash.now[:warning] = t('.fail')
        render :edit, status: :unprocessable_entity
      else
        redirect_to drink_record_path(@drink_record), success: t('.success')
      end
    else
      render :edit
    end
  end

  def destroy
    @drink_record = DrinkRecord.find(params[:id])
    @drink_record.destroy
    redirect_to mypage_calendar_path, success: t('.success')
  end

  private

  def drink_record_params
    if params[:drink_record].present?
      morning_suggestion_id = params[:drink_record][:morning_suggestion]
      afternoon_suggestion_id = params[:drink_record][:afternoon_suggestion]
      evening_suggestion_id = params[:drink_record][:evening_suggestion]
    else
      morning_suggestion_id = params[:morning_suggestion]
      afternoon_suggestion_id = params[:afternoon_suggestion]
      evening_suggestion_id = params[:evening_suggestion]
    end

    # ドリンクデータベースから対応するドリンクオブジェクトを取得
    morning_suggestion = Drink.find(morning_suggestion_id)
    afternoon_suggestion = Drink.find(afternoon_suggestion_id)
    evening_suggestion = Drink.find(evening_suggestion_id)

    params.permit(:caffeine_total, :date).merge(
      user: current_user,
      morning_suggestion:,
      afternoon_suggestion:,
      evening_suggestion:
    )
  end
end
