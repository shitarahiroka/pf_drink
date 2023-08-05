class Drink < ApplicationRecord
    attr_accessor :study_time, :calorie_preference
    def display_name
        name
    end
end