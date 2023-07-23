class ChangeCustomerIdToUuid < ActiveRecord::Migration[7.0]
  def change
    change_table :customers, id: :uuid do |t|
      t.remove :id
      t.uuid :id, default: -> { "gen_random_uuid()" }, primary_key: true
    end
  end
end
