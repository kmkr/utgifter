class TransactionBatchesController < ApplicationController
  respond_to :json

  def create
    transaction_batch = TransactionBatch.create(params[:transaction_batch])
    transactions = transaction_batch.convert_to_transactions

    respond_to do |format|
      format.json { render :json => transactions }
    end
  end

end
