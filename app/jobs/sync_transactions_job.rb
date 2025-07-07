class SyncTransactionsJob < ApplicationJob
  queue_as :default

  retry_on ChainApiService::ApiError, wait: :exponentially_longer, attempts: 3

  def perform(chain_id = nil)
    chains = chain_id ? [Chain.find(chain_id)] : Chain.active
    process_chains(chains)
  end

  private

  def process_chains(chains)
    chains.each_with_object({ processed: 0, errors: [] }) do |chain, result|
      chain_result = sync_chain_transactions(chain)
      result[:processed] += chain_result[:processed]
      result[:errors].concat(chain_result[:errors])
    end
  end

  def sync_chain_transactions(chain)
    transactions_data = ChainApiService.new(chain).fetch_transactions

    processor = TransactionProcessorService.new(chain, transactions_data)
    result = processor.process_transactions

    result
  rescue StandardError => e
    Rails.logger.error "Failed to sync transactions for #{chain.name}: #{e.message}"
    raise e
  end
end
