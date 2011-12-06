class Transaction < ActiveRecord::Base
  belongs_to :transaction_batch
  default_scope :order => 'time desc'
end
