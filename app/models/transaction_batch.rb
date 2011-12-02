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
    expense_group_id = find_expense_group_id(batch_line)
    amount = find_amount(batch_line)

    Transaction.new({
      :time => timestamp,
      :description => description,
      :amount => amount,
      :expense_group_id => expense_group_id
    })
  end

  def find_timestamp(batch_line)
     Date.new
  end

  def find_description(batch_line)
    "description"
  end

  def find_expense_group_id(batch_line)
    1
  end

  def find_amount(batch_line)
    "amount"
  end

end
