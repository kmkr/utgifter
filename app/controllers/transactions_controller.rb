class TransactionsController < ApplicationController
  respond_to :json
  respond_to :html, :only => [ :index ]

  def index
    @transaction_groups = TransactionGroup.all(:include => :transactions)
  end

  def create
    @transaction = Transaction.create(params[:transaction])

    respond_with @transaction
  end

  def destroy
  end

end
