class CreateDrinkRecords < ActiveRecord::Migration[7.0]
  def change
    create_table :drink_records do |t|
      t.references :user, foreign_key: true
      t.string :morning_suggestion
      t.string :afternoon_suggestion
      t.string :evening_suggestion
      t.float :caffeine_total
      t.date :date
      t.timestamps
    end
  end
end
