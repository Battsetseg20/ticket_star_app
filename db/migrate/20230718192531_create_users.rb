class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users, id: :uuid do |t|
      t.string :email, null: false
      t.string :encrypted_password, null: false
      t.string :username
      t.string :firstname
      t.string :lastname
      t.date :birthdate
      # t.references :address, foreign_key: true
    
      t.timestamps
    end

    add_index :users, :email, unique: true
    add_index :users, :username, unique: true

    change_column_null :users, :email, false
    change_column_null :users, :encrypted_password, false
  end
end
