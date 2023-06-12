class DrinkRecordsController < ApplicationController
    def create
        @drink_record = DrinkRecord.new(drink_record_params)
        if @drink_record.save
            redirect_to mypage_calendar_path, notice: '診断結果が保存されました。'
        else
            redirect_to mypage_calendar_path, alert: '診断結果の保存に失敗しました。'
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
