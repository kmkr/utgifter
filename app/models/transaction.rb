class Transaction < ActiveRecord::Base
  belongs_to :transaction_batch
  belongs_to :expense_group
end
