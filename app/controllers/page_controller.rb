class PageController < ApplicationController
  def show
    @categories = Category.all
    @expenses = Expense.all
  end

end
