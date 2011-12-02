class CreateTransactionBatches < ActiveRecord::Migration
  def change
    create_table :transaction_batches do |t|
      t.string :content

      t.timestamps
    end
  end
end
