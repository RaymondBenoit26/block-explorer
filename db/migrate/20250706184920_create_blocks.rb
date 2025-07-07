class CreateBlocks < ActiveRecord::Migration[8.0]
  def change
    create_table :blocks do |t|
      t.references :chain, null: false, foreign_key: true
      t.integer :height, null: false
      t.string :block_hash, null: false
      t.datetime :timestamp

      t.timestamps
    end
    
    add_index :blocks, :block_hash, unique: true
    add_index :blocks, [:chain_id, :height], unique: true
  end
end
