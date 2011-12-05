class ExpenseGroupsController < ApplicationController
  def index
    @expense_groups = ExpenseGroup.all
  end

  def new
    @expense_group = ExpenseGroup.new
  end

  def create
    @expense_group = ExpenseGroup.create(params[:expense_group])

    redirect_to expense_groups_path
  end

end
