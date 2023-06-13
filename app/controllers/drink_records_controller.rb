class DrinkRecordsController < ApplicationController
    def create
        existing_record = DrinkRecord.find_by(user_id: current_user.id, date: params[:date])
        if existing_record.present?
            redirect_to mypage_calendar_path, flash: { notice: '既に記録が存在します。上書きせずにマイページに戻ります。' }
        else
            @drink_record = DrinkRecord.new(drink_record_params)
            if @drink_record.save
                redirect_to mypage_calendar_path, flash: { notice: '診断結果が保存されました。' }
            else
                redirect_to mypage_calendar_path, alert: '診断結果の保存に失敗しました。'
            end
        end
    end

    def show
        @drink_record = DrinkRecord.find(params[:id])
    end

    private

    def drink_record_params
        morning_suggestion_id = params[:morning_suggestion]
        afternoon_suggestion_id = params[:afternoon_suggestion]
        evening_suggestion_id = params[:evening_suggestion]

        # ドリンクデータベースから対応するドリンクオブジェクトを取得
        morning_suggestion = Drink.find(morning_suggestion_id)
        afternoon_suggestion = Drink.find(afternoon_suggestion_id)
        evening_suggestion = Drink.find(evening_suggestion_id)

        params.permit(:caffeine_total, :date).merge(
            user: current_user,
            morning_suggestion: morning_suggestion,
            afternoon_suggestion: afternoon_suggestion,
            evening_suggestion: evening_suggestion
        )
    end

end
