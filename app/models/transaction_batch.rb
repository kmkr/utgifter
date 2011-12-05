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
    transaction_group_id = find_transaction_group_id(batch_line)
    amount = find_amount(batch_line)

    Transaction.new({
      :time => timestamp,
      :description => description,
      :amount => amount,
      :transaction_group_id => transaction_group_id
    })
  end

  def find_timestamp(batch_line)
    # todo: regexp out tidspunkt
     Time.new
  end

  def find_description(batch_line)
    # todo: regexp out beskrivelse
    "description"
  end

  def find_transaction_group_id(description)
    # todo: bruk beskrivelse til å bestemme hvilken expense group. hjelpeklasse, regelmotor?
    1
  end

  def find_amount(batch_line)
    # todo: regexp out beløp
    "amount"
  end

end
