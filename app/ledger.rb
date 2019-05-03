require_relative '../config/sequel'

module ExpenseTracker
  RecordResult = Struct.new(:success?, :expense_id, :error_message)

  EXPECTED_KEYS = ['payee', 'amount', 'date']

  class Ledger
    def record(expense)
      missing_keys = EXPECTED_KEYS - expense.keys
      if missing_keys.any?
        message = "Invalid expense: `#{missing_keys.join(',')}` #{pluralize(missing_keys.count, 'is', 'are')} required"
        return RecordResult.new(false, nil, message)
      end

      DB[:expenses].insert(expense)
      id = DB[:expenses].max(:id)
      RecordResult.new(true, id, nil)
    end

    def expenses_on(date)
      DB[:expenses].where(date: date).all
    end

    def pluralize(n, singular, plural=nil)
      if n == 1
          "#{singular}"
      elsif plural
          "#{plural}"
      else
          "#{singular}s"
      end
    end
  end
end
