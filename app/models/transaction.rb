class Transaction < ActiveRecord::Base
  belongs_to :transaction_batch
end
