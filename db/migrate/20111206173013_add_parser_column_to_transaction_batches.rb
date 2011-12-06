class AddParserColumnToTransactionBatches < ActiveRecord::Migration
  def change
    add_column :transaction_batches, :parser, :string
  end
end
