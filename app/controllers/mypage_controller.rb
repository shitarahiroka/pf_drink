class MypageController < ApplicationController
    def calendar
        @user = current_user
        @caffeine_limit = @user.calculate_caffeine_limit
        @drink_records = DrinkRecord.all
    end
end
