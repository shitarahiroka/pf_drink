class AddForeignKeysToDrinkRecords < ActiveRecord::Migration[7.0]
  def change
    add_foreign_key :drink_records, :drinks, column: :morning_suggestion
    add_foreign_key :drink_records, :drinks, column: :afternoon_suggestion
    add_foreign_key :drink_records, :drinks, column: :evening_suggestion
  end
end
