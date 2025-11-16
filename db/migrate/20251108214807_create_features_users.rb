class CreateFeaturesUsers < ActiveRecord::Migration[8.1]
  def change
    create_table :features_users, id: :uuid do |t|
      t.references :user, null: false, foreign_key: true, type: :uuid
      t.references :feature, null: false, foreign_key: true, type: :uuid
      t.integer :quota

      t.timestamps
    end
  end
end
