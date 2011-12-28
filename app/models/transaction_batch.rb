class TransactionBatch < ActiveRecord::Base
  has_many :transactions
  belongs_to :user
  attr_protected :user_id

  def convert_to_transactions
    transactions = []

    content.each_line do |line|
      transactions << create_transaction(line)
    end

    transactions
  end

  private

  def create_transaction(batch_line)
    time = nil
    description = nil
    amount = nil
    errors = []
    begin
      time = find_time(batch_line)
    rescue
      logger.error "Unable to parse time from #{batch_line} using parser #{parser}"
      errors.push("time")
    end

    begin
      description = find_description(batch_line)
    rescue
      logger.error "Unable to parse description from #{batch_line} using parser #{parser}"
      errors.push("description")
    end

    begin
      amount = find_amount(batch_line)
    rescue
      logger.error "Unable to parse amount from #{batch_line} using parser #{parser}"
      errors.push("amount")
    end

    Transaction.new({
      :time => time,
      :description => description,
      :amount => amount,
      :errors => errors
    })
  end

  def find_time(batch_line)
    begin
      if parser == "dnb"
        dateTokens = batch_line.split(";").first.split(".")
        day = dateTokens.first
        month = dateTokens.second
        year = "20" + dateTokens.third
        raise "parse error" unless year.size == 4
        return Time.mktime(year.to_i, month.to_i, day.to_i)
      elsif parser == "sb1"
        dateTokens = batch_line.split(";").first.split(".")
        day = dateTokens.first
        month = dateTokens.second
        year = dateTokens.third
        return Time.mktime(year.to_i, month.to_i, day.to_i)
      else
        batch_line.match(/\d{2}\.\d{2}\.\d{4}/).to_s.strip
      end
    rescue
      raise "parse error #{$!}"
    end
  end

  def find_description(batch_line)
    desc = ""
    begin
      if parser == "dnb"
        desc = batch_line.split(";").second.gsub(/\"/, "")
      elsif parser == "sb1"
        desc = batch_line.split(";").second
      else
        desc = batch_line
      end
    rescue
      logger.warn "Unable to parse description from '#{batch_line}' using parser #{parser}."
      raise "parse error #{$!}"
    end

    return desc if desc.length > 3 # min 3, can be like "visa"

    raise "parse error #{$!}"
  end

  def find_amount(batch_line)
    begin
      if parser == "dnb"
        fields = batch_line.split(";")
        out = fields[3].sub(/,/, ".").to_f * -1
        income = fields[4].sub(/,/, ".").to_f

        return income unless income == 0
        return out
      elsif parser == "sb1"
        batch_line.split(";")[3].sub(/,/, ".").to_f
      else
        line = batch_line.gsub(/\t/, "    ").rstrip
        match = line.match(/-?\d(\s?\d)*,\d{1,2}$/).to_s
        match.sub(/,/, ".").gsub(/\s/, "").strip
      end
    rescue
      raise "parse error #{$!}"
    end
  end

end
