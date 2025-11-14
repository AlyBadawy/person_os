class CreateFeatures < ActiveRecord::Migration[8.1]
  def change
    create_table :features, id: :uuid do |t|
      t.string :name
      t.jsonb :metadata

      t.timestamps
    end

    add_index :features, :name, unique: true
  end
end
