class TransactionProcessorService
  attr_reader :chain, :transactions_data

  def initialize(chain, transactions_data)
    @chain = chain
    @transactions_data = transactions_data
  end

  def process_transactions
    return { processed: 0, errors: [] } if transactions_data.blank?

    transactions_data.each_with_object({ processed: 0, errors: [] }) do |transaction_data, result|
      begin
        process_single_transaction(transaction_data)
        result[:processed] += 1
      rescue StandardError => e
        result[:errors] << "Transaction #{transaction_data["hash"]}: #{e.message}"
      end
    end
  end

  private

  def process_single_transaction(transaction_data)
    return if Transaction.exists?(transaction_hash: transaction_data["hash"])

    block = find_or_create_block(transaction_data)
    transaction = block.transactions.create!(
      transaction_hash: transaction_data["hash"],
      gas_burnt: transaction_data["gas_burnt"]
    )

    process_actions(transaction, transaction_data)

    transaction
  end

  def find_or_create_block(transaction_data)
    @chain.blocks.find_or_create_by(
      height: transaction_data["height"],
      block_hash: transaction_data["block_hash"]
    ) do |block|
      block.timestamp = parse_timestamp(transaction_data["time"])
    end
  end

  def process_actions(transaction, transaction_data)
    return unless transaction_data["actions"]&.any?

    transaction_data["actions"].each do |action_data|
      deposit = 0
      deposit = action_data.dig("data", "deposit") if action_data.dig("data", "deposit")

      transaction.transaction_actions.create!(
        action_type: action_data["type"].downcase,
        sender: transaction_data["sender"],
        receiver: transaction_data["receiver"],
        deposit: deposit
      )
    end
  end

  def parse_timestamp(timestamp_str)
    return nil unless timestamp_str

    if timestamp_str.is_a?(String)
      Time.parse(timestamp_str)
    elsif timestamp_str.is_a?(Integer)
      Time.at(timestamp_str)
    else
      nil
    end
  rescue StandardError
    nil
  end
end
