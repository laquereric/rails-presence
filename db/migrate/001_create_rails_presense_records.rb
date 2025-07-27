class CreateRailsPresenseRecords < ActiveRecord::Migration[5.0]
  def change
    create_table :rails_presense_records do |t|
      t.integer :user_id, null: false
      t.string :identifier, null: false, default: 'default'
      t.datetime :last_seen_at, null: false
      t.text :metadata

      t.timestamps null: false
    end

    add_index :rails_presense_records, [:user_id, :identifier], unique: true
    add_index :rails_presense_records, :last_seen_at
    add_index :rails_presense_records, :user_id
  end
end
