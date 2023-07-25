class CreateTickets < ActiveRecord::Migration[7.0]
  def change
    create_table :tickets, id: :uuid do |t|
      t.references :event_item, null: false, foreign_key: true, type: :uuid, index: true
      t.decimal :price, precision: 10, scale: 2
      t.integer :quantity_available

      t.timestamps
    end
  end
end


