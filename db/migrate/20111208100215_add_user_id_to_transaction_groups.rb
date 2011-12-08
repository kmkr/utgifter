class AddUserIdToTransactionGroups < ActiveRecord::Migration
  def change
    add_column :transaction_groups, :user_id, :integer
  end
end
