class CreateExpenseGroups < ActiveRecord::Migration
  def change
    create_table :expense_groups do |t|
      t.string :title

      t.timestamps
    end
  end
end
