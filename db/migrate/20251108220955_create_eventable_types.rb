class CreateEventableTypes < ActiveRecord::Migration[8.1]
  def change
    create_table :eventable_types, id: :uuid do |t|
      t.string :name, null: false
      t.jsonb :metadata

      t.timestamps
    end

    add_index :eventable_types, :name, unique: true
  end
end
