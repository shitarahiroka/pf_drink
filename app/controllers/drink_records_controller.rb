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

    def edit
        @drink_record = DrinkRecord.find(params[:id])
    end

    def update
        @drink_record = DrinkRecord.find(params[:id])
        if @drink_record.update(drink_record_params)
            update_caffeine_total
            redirect_to drink_record_path(@drink_record), flash: { notice: 'ドリンク記録が更新されました。' }
        else
            render :edit
        end
    end

    def destroy
        @drink_record = DrinkRecord.find(params[:id])
        @drink_record.destroy
        redirect_to mypage_calendar_path, flash: { notice: 'ドリンク記録が削除されました。' }
    end

    private

    def drink_record_params
        morning_suggestion_id = params[:drink_record][:morning_suggestion]
        afternoon_suggestion_id = params[:drink_record][:afternoon_suggestion]
        evening_suggestion_id = params[:drink_record][:evening_suggestion]

        # ドリンクデータベースから対応するドリンクオブジェクトを取得
        morning_suggestion = Drink.find(morning_suggestion_id)
        afternoon_suggestion = Drink.find(afternoon_suggestion_id)
        evening_suggestion = Drink.find(evening_suggestion_id)

        params.require(:drink_record).permit(:caffeine_total, :date).merge(
            user: current_user,
            morning_suggestion: morning_suggestion,
            afternoon_suggestion: afternoon_suggestion,
            evening_suggestion: evening_suggestion
        )
    end

    def update_caffeine_total
        morning_suggestion = @drink_record.morning_suggestion.caffeine.to_i
        afternoon_suggestion = @drink_record.afternoon_suggestion.caffeine.to_i
        evening_suggestion = @drink_record.evening_suggestion.caffeine.to_i

        # 各摂取量を合計してカフェイン総摂取量を計算
        caffeine_total = morning_suggestion + afternoon_suggestion + evening_suggestion

        # カフェイン総摂取量を更新
        @drink_record.update(caffeine_total: caffeine_total)
    end
end
