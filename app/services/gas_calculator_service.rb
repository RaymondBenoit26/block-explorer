class GasCalculatorService
  def initialize(chain = nil)
    @chain = chain
    set_gas_values
  end

  GasStats = Struct.new(:total, :count, :min, :max) do
    def self.from_values(values)
      return new(0, 0, nil, nil) if values.nil? || values.empty?

      total = values.sum
      count = values.size
      min, max = values.minmax
      new(total, count, min, max)
    end

    def average
      return 0 if empty?
      (total.to_f / count).round(2)
    end

    def empty?
      count.zero?
    end
  end

  def gas_statistics
    @gas_stats ||= GasStats.from_values(@gas_values)
  end

  private

  def transaction_scope
    @chain ? @chain.transactions : Transaction.all
  end

  def set_gas_values
    @gas_values = transaction_scope.where.not(gas_burnt: nil).pluck(:gas_burnt)
  end
end
