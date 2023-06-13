class DrinkRecord < ApplicationRecord
    belongs_to :user
    belongs_to :morning_suggestion, class_name: "Drink", foreign_key: "morning_suggestion"
    belongs_to :afternoon_suggestion, class_name: "Drink", foreign_key: "afternoon_suggestion"
    belongs_to :evening_suggestion, class_name: "Drink", foreign_key: "evening_suggestion"
    validates :morning_suggestion, presence: true
    validates :afternoon_suggestion, presence: true
    validates :evening_suggestion, presence: true
    validates :caffeine_total, presence: true
    validates :date, presence: true
    validates :user_id, uniqueness: { scope: :date, message: 'Record for this date already exists.' }
end