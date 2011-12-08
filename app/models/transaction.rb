class Transaction < ActiveRecord::Base
  belongs_to :transaction_batch
  belongs_to :user
  default_scope :order => 'time desc'
  attr_protected :user_id
end
