class ChangeExpenseIdToTransId < ActiveRecord::Migration
  def change
    rename_column :transactions, :expense_group_id, :transaction_group_id
  end

end
