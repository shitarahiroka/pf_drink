class SorceryCore < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :email,            null: false, index: { unique: true }
      t.string :crypted_password
      t.string :salt
      t.string :name, null: false
      t.integer :weight
      t.integer :age
      t.integer :gender
      t.integer :area

      t.timestamps                null: false
    end

    add_index :users, :email, unique: true
  end
end