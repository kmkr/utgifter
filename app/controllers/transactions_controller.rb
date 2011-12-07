class TransactionsController < ApplicationController
  respond_to :json
  respond_to :html, :only => [ :index ]

  def index
    @transactions = Transaction.all

    respond_with @transactions
  end

  def update
    transaction = Transaction.find(params[:id])
    transaction.update_attributes(params[:transaction])

    head: ok
  end

  def create
    @transaction = Transaction.create(params[:transaction])

    respond_with @transaction
  end

  def destroy
    transaction = Transaction.find(params[:id])
    transaction.destroy

    head: ok
  end

end
