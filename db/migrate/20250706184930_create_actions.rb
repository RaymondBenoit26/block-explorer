class CreateActions < ActiveRecord::Migration[8.0]
  def change
    create_table :actions do |t|
      t.references :transaction, null: false, foreign_key: true
      t.string :action_type, null: false
      t.string :sender
      t.string :receiver
      t.decimal :deposit, precision: 30, scale: 0

      t.timestamps
    end
    
    add_index :actions, :action_type
    add_index :actions, [:action_type, :sender, :receiver]
  end
end
