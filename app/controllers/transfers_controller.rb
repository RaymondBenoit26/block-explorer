class TransfersController < ApplicationController
  def index
    @transfers = TransactionAction.transfers
                                  .includes(txn: { block: :chain })
                                  .order(created_at: :desc)
                                  .limit(50)

    @gas_statistics = GasCalculatorService.new.gas_statistics

    @chains = Chain.all
    @has_data = @transfers.any?

    @last_sync = Transaction.maximum(:created_at)
  end
end
