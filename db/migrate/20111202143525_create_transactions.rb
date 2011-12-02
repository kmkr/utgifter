class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.datetime :time
      t.integer :transaction_batch_id
      t.integer :expense_group_id
      t.decimal :amount, :precision => 8, :scale => 2

      t.timestamps
    end
  end
end
