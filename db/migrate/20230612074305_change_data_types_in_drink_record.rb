class ChangeDataTypesInDrinkRecord < ActiveRecord::Migration[7.0]
  def up
    change_column :drink_records, :morning_suggestion, :bigint
    change_column :drink_records, :afternoon_suggestion, :bigint
    change_column :drink_records, :evening_suggestion, :bigint
  end

  def down
    change_column :drink_records, :morning_suggestion, :integer
    change_column :drink_records, :afternoon_suggestion, :integer
    change_column :drink_records, :evening_suggestion, :integer
  end
end