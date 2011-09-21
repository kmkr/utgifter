class Category < ActiveRecord::Base
  has_many :filters
  def expenses
    myExpenses = []
    Expense.all.each do |expense|
      myExpenses << expense if filter_match?(expense)
    end

    myExpenses
  end

  def expense_count
    count = 0
    Expense.all.each do |expense|
      count += expense.amount if filter_match?(expense) 
    end

    count
  end

  private

  def filter_match?(expense)
      self.filters.select { |f| expense.content =~ f }
  end
end
