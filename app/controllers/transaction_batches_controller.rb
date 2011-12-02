class TransactionBatchesController < ApplicationController
  def new
    @transaction_batch = TransactionBatch.new
  end

  def create
  end

end
