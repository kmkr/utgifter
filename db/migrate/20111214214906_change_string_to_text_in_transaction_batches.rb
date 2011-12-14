class ChangeStringToTextInTransactionBatches < ActiveRecord::Migration
  def change
    change_column :transaction_batches, :content, :text
    change_column :transaction_groups, :regex, :string
  end

end
