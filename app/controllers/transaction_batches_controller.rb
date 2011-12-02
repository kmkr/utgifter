class TransactionBatchesController < ApplicationController
  def new
    @transaction_batch = TransactionBatch.new
  end

  def create
    transaction_batch = TransactionBatch.create(params[:transaction_batch])

    @transactions = transaction_batch.convert_to_transactions
  end

end
