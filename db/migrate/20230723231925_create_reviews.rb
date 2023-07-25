class CreateReviews < ActiveRecord::Migration[7.0]
  def change
    create_table :reviews, id: :uuid do |t|
      t.references :event_item, null: false, foreign_key: true, type: :uuid, index: true
      t.references :user, null: false, foreign_key: true, type: :uuid, index: true
      t.integer :rating
      t.text :comment

      t.timestamps
    end
  end
end
