class TransactionGroupsController < ApplicationController

  respond_to :json, :only => [ :index ]
  respond_to :html

  def index
    @transaction_groups = TransactionGroup.all

    respond_with @transaction_groups
  end

  def new
    @transaction_group = TransactionGroup.new
  end

  def create
    @transaction_group = TransactionGroup.create(params[:transaction_group])

    head :ok
  end

  def update
    transaction_group = TransactionGroup.find(params[:id])
    transaction_group.update_attributes(params[:transaction_group])
    
    head :ok
  end

  def destroy
    transaction_group = TransactionGroup.find(params[:id])
    transaction_group.destroy
    
    head :ok
  end

end
