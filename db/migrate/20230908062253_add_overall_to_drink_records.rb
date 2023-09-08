class AddOverallToDrinkRecords < ActiveRecord::Migration[7.0]
  def change
    add_column :drink_records, :overall, :integer
  end
end
