class DrinkRecord < ApplicationRecord
    belongs_to :user
    validates :morning_suggestion, presence: true
    validates :afternoon_suggestion, presence: true
    validates :evening_suggestion, presence: true
    validates :caffeine_total, presence: true
    validates :date, presence: true
end