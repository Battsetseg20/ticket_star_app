class CreateEventOrganizers < ActiveRecord::Migration[7.0]
  def change
    create_table :event_organizers do |t|
      t.references :user, null: false, foreign_key: true,  type: :uuid

      t.timestamps
    end
  end
end
