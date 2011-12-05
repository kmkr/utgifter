class Transaction < ActiveRecord::Base
  belongs_to :transaction_batch
  belongs_to :transaction_group

  validates_presence_of :transaction_group_id
end
