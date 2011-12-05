class ExpenseGroup < ActiveRecord::Base
  has_many :transactions

  scope :by_description, lambda { |description|
    result = []

    self.all.each do |entry|
      result << entry if description =~ /#{entry.regex}/i
    end

    result
  }

end
