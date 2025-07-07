class CreateTransactions < ActiveRecord::Migration[8.0]
  def change
    create_table :transactions do |t|
      t.references :block, null: false, foreign_key: true
      t.string :transaction_hash, null: false
      t.bigint :gas_burnt

      t.timestamps
    end
    
    add_index :transactions, :transaction_hash, unique: true
  end
end
