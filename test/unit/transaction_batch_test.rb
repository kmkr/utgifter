require 'test_helper'

class TransactionBatchTest < ActiveSupport::TestCase

  test "correct creation of withdrawal" do
    tb = TransactionBatch.new
    tb.content = "28.11.2011  VARER: 27.11 RESTAURANT DAHL MARIDALSVN 4 OSLO  28.11.2011  -600,00"
    
    transactions = tb.convert_to_transactions

    assert_equal(1, transactions.size)

    transaction = transactions.first
    assert_equal(tb.content, transaction.description)
    assert_equal(-600, transaction.amount)
    assert_equal(2011, transaction.time.year)
    assert_equal(28, transaction.time.day)
    assert_equal(11, transaction.time.month)
  end

  test "correct creation of withdrawal above one thousand kroner" do
    tb = TransactionBatch.new
    tb.content = "29.11.2011  MINIBANK-UTTAK I FREMMED BANK: 28.11 BNP Alexander Kiellands 0171 Oslo  28.11.2011  -1 400,00"
    
    transactions = tb.convert_to_transactions

    assert_equal(1, transactions.size)

    transaction = transactions.first
    assert_equal(tb.content, transaction.description)
    assert_equal(-1400, transaction.amount)
    assert_equal(2011, transaction.time.year)
    assert_equal(29, transaction.time.day)
    assert_equal(11, transaction.time.month)
  end

  test "correct creation of withdrawal above one million kroner" do
    tb = TransactionBatch.new
    tb.content = "29.11.2011  MINIBANK-UTTAK I FREMMED BANK: 28.11 BNP Alexander Kiellands 0171 Oslo  28.11.2011  -1 230 400,00"
    
    transactions = tb.convert_to_transactions
    transaction = transactions.first
    assert_equal(-1230400, transaction.amount)
  end

  test "correct creation of wage with tab" do
    tb = TransactionBatch.new
    tb.content = "22.11.2011  OVERFORSEL: Fra: ITERA CONSULTING AS Betalt: 21.11.11 22.11.2011	1 281,55"
    
    transactions = tb.convert_to_transactions

    assert_equal(1, transactions.size)

    transaction = transactions.first
    assert_equal(1281.55, transaction.amount)
    assert_equal(2011, transaction.time.year)
    assert_equal(22, transaction.time.day)
    assert_equal(11, transaction.time.month)
  end

  test "correct creation of withdrawal with trailing space" do
    tb = TransactionBatch.new
    tb.content = "05.12.2011  NETTGIRO M/MELD. FORFALL I DAG: Nettgiro til: LARSEN ANDERS H Betalt: 03.12.11  03.12.2011  -100,00       "
    
    transactions = tb.convert_to_transactions

    transaction = transactions.first
    assert_equal(-100, transaction.amount)
  end

end
