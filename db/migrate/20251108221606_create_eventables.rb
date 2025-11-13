class CreateEventables < ActiveRecord::Migration[8.1]
  def change
    create_table :eventables, id: :uuid do |t|
      t.references :user, null: false, foreign_key: true, type: :uuid
      t.references :eventable_type, null: false, foreign_key: true, type: :uuid
      t.string :name, null: false
      t.jsonb :schedule, null: false, default: {}
      t.date :starts_on
      t.date :ends_on
      t.jsonb :metadata, null: false, default: {}

      t.timestamps
    end

    add_index :eventables, [:user_id, :eventable_type_id, :name], unique: true, name: 'index_eventables_on_user_eventable_type_and_name'
  end
end
