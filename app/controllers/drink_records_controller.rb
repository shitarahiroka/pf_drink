class DrinkRecordsController < ApplicationController
    def create
        @drink_record = DrinkRecord.new(drink_record_params)
        if @drink_record.save
            redirect_to mypage_calendar_path, notice: '診断結果が保存されました。'
        else
            redirect_to mypage_calendar_path, alert: '診断結果の保存に失敗しました。'
        end
    end

    private

    def drink_record_params
        params.permit(:morning_suggestion, :afternoon_suggestion, :evening_suggestion, :caffeine_total, :date).merge(user: current_user)
    end

end
