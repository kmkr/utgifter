class AddRulesToExpenseGroup < ActiveRecord::Migration
  def change
    add_column :expense_groups, :regex, :text
  end
end
