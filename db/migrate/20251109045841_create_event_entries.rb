class CreateEventEntries < ActiveRecord::Migration[8.1]
  def change
    create_table :event_entries, id: :uuid do |t|
      t.references :eventable, null: true, foreign_key: true, type: :uuid
      t.datetime :occurred_at, null: true
      t.jsonb :metadata, null: false, default: {}

      t.timestamps
    end
  end
end
