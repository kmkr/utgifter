class Transaction < ActiveRecord::Base
  belongs_to :transaction_batch
  belongs_to :user
  default_scope :order => 'time desc'
  attr_protected :user_id

  attr_accessor :errors

  def errors
    @errors || []
  end

  def as_json(options)
    options = {} unless options
    options[:methods] = :errors
    super(options)
  end
end
