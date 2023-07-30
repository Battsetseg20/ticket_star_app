class AddTypetoEventItems < ActiveRecord::Migration[7.0]
  def change
    add_column :event_items, :event_type, :integer, default: 0
  end
end
