class TransactionGroupsController < ApplicationController

  respond_to :json

  def index
    @transaction_groups = current_user.transaction_groups

    respond_with @transaction_groups
  end

  def create
    transaction_group = TransactionGroup.new(params[:transaction_group])
    transaction_group.user = current_user

    if transaction_group.save
      respond_with transaction_group
    else
      head :bad_request
    end
  end

  def update
    transaction_group = current_user.transaction_groups.where(:id => params[:id]).first

    if transaction_group
      transaction_group.update_attributes(params[:transaction_group])
      respond_with transaction_group
    else
      head :forbidden
    end
  end

  def destroy
    transaction_group = current_user.transaction_groups.where(:id => params[:id]).first

    if transaction_group
      transaction_group.destroy
      head :ok
    else
      head :forbidden
    end
  end

end
