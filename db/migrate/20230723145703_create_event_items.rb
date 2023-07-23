class CreateEventItems < ActiveRecord::Migration[7.0]
  def change
    create_table :event_items, id: :uuid do |t|
      t.string :title
      t.text :description
      t.date :date
      t.time :time
      t.string :location
      t.integer :status, default: 0
      t.references :event_organizer, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
