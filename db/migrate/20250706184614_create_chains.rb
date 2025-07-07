class CreateChains < ActiveRecord::Migration[8.0]
  def change
    create_table :chains do |t|
      t.string :name, null: false
      t.string :api_endpoint, null: false
      t.string :api_key
      t.integer :scale_factor, null: false

      t.timestamps
    end
    
    add_index :chains, :name, unique: true
  end
end
