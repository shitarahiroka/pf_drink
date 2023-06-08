class MypageController < ApplicationController
    def calendar
        @drink_records = DrinkRecord.all
    end
end
