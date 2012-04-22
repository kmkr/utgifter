class AddYearToTransactionBatches < ActiveRecord::Migration
  def change
    add_column :transaction_batches, :year, :integer
  end
end
