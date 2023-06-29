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
        if @drink_record.update(drink_record_params)
            update_caffeine_total
            redirect_to drink_record_path(@drink_record), success: t('.success')
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
