class TransactionGroupsController < ApplicationController

  def index
    @transaction_groups = TransactionGroup.all
  end

  def new
    @transaction_group = TransactionGroup.new
  end

  def create
    @transaction_group = TransactionGroup.create(params[:transaction_group])

    redirect_to transaction_groups_path
  end

  def update
    transaction_group = TransactionGroup.find(params[:id])
    transaction_group.update_attributes(params[:transaction_group])

    redirect_to transaction_groups_path
  end

  def destroy
    transaction_group = TransactionGroup.find(params[:id])
    transaction_group.destroy
    
    redirect_to transaction_groups_path
  end

end
