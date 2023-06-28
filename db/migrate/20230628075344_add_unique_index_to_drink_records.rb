class AddUniqueIndexToDrinkRecords < ActiveRecord::Migration[7.0]
  def change
    add_index :drink_records, [:user_id, :date], unique: true
  end
end
