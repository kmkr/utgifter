class TransactionBatchesController < ApplicationController
  respond_to :json

  def create
    transaction_batch = TransactionBatch.new(params[:transaction_batch])
    puts params[:transaction_batch]
    transaction_batch.user = current_user
    if transaction_batch.save
      transactions = transaction_batch.convert_to_transactions

      respond_to do |format|
        format.json { render :json => transactions }
      end
    else
      head :bad_request
    end
  end

  def index
    tbs = TransactionBatch.all

    respond_to do |format|
      format.json { render :json => tbs }
    end
  end

end
