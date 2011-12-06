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
    amount = find_amount(batch_line)

    Transaction.new({
      :time => timestamp,
      :description => description,
      :amount => amount
    })
  end

  def find_timestamp(batch_line)
    # todo: kast exception dersom tidspunkt ikke finnes
    batch_line.match(/\d{2}\.\d{2}\.\d{4}/).to_s.strip
  end

  def find_description(batch_line)
    # todo: regexp out beskrivelse
    batch_line
  end

  def find_amount(batch_line)
    line = batch_line.gsub(/\t/, "    ").chomp
    match = line.match(/-?\d(\s?\d)*,\d{1,2}$/).to_s
    match.sub(/,/, ".").gsub(/\s/, "").strip
  end

end
