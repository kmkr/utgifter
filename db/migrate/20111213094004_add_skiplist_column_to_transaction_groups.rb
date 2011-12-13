class AddSkiplistColumnToTransactionGroups < ActiveRecord::Migration
  def change
    add_column :transaction_groups, :use_as_skiplist, :boolean, :default => false
  end
end
