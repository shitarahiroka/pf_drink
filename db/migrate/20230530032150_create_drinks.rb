class CreateDrinks < ActiveRecord::Migration[7.0]
  def change
    create_table :drinks do |t|
      t.string :name
      t.float :calories
      t.float :caffeine
      t.integer :teanine
      t.string :mood

      t.timestamps
    end
  end
end
