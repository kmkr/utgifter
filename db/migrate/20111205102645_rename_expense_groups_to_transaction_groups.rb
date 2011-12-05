class RenameExpenseGroupsToTransactionGroups < ActiveRecord::Migration
  def change
    rename_table :expense_groups, :transaction_groups
  end

end
