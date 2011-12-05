require 'test_helper'

class ExpenseGroupTest < ActiveSupport::TestCase
  test "description scope for simple regex" do
    assert_equal(expense_groups(:fun), ExpenseGroup.by_description('villa').first)
  end

  test "description scope for complex regex" do
    assert_equal(expense_groups(:mat), ExpenseGroup.by_description('meny').first)
  end

  test "description scope for case insensitivity" do
    assert_equal(expense_groups(:mat), ExpenseGroup.by_description('MEnY').first)
  end

  test "description scope for multi word line" do
    assert_equal(expense_groups(:mat), ExpenseGroup.by_description('Indre havn MEnY sandefjord').first)
  end
end
