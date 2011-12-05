class TransactionsController < ApplicationController
  respond_to :json

  def create
    @transaction = Transaction.create(params[:transaction])

    respond_with @transaction
  end

  def destroy
  end

end
