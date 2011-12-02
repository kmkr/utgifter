class TransactionBatch < ActiveRecord::Base
  has_many :transactions

  def convert_to_transactions
    transactions = []

    content.each_line do |line|
      transactions << create_transaction(line)
    end

    transactions
  end

  private

  def create_transaction(batch_line)
    timestamp = find_timestamp(batch_line)
    description = find_description(batch_line)

    Transaction.new({
      :time => timestamp,
      :description => description
    })
  end

  def find_timestamp(batch_line)
     Date.new
  end

  def find_description(batch_line)
    "description"
  end

end
