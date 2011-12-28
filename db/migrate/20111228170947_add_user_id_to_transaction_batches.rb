class AddUserIdToTransactionBatches < ActiveRecord::Migration
  def change
    add_column :transaction_batches, :user_id, :integer
    user = User.find_by_email 'krismikael@gmail.com'
    if user
      TransactionBatch.all.each do |tb|
        tb.user = user
        tb.save
      end
    end
  end
end
