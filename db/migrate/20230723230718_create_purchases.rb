class CreatePurchases < ActiveRecord::Migration[7.0]
  def change
    create_table :purchases, id: :uuid do |t|
      t.references :customer, null: false, foreign_key: true, type: :uuid
      t.references :ticket, null: false, foreign_key: true, type: :uuid
      t.integer :quantity, null: false, default: 1
      t.decimal :purchase_total, null: false, precision: 10, scale: 2
      t.string :status, null: false, default: "pending"

      t.timestamps
    end
  end
end

