class CreateFilters < ActiveRecord::Migration
  def change
    create_table :filters do |t|
      t.integer :category_id
      t.string :content

      t.timestamps
    end
  end
end
