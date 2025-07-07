namespace :blockchain do
  desc "Sync transactions for all active chains"
  task sync_all: :environment do
    puts "Starting blockchain sync..."
    
    result = SyncTransactionsJob.perform_now
    
    puts "Sync completed successfully!"
    puts "Summary:"
    puts "  - Processed transactions: #{result[:processed] || 'N/A'}"
    puts "  - Errors: #{result[:errors]&.size || 0}"
    
    if result[:errors]&.any?
      puts "Errors encountered:"
      result[:errors].each { |error| puts "  - #{error}" }
    end
  end
  
  desc "Sync transactions for a specific chain"
  task :sync_chain, [:chain_name] => :environment do |_task, args|
    chain_name = args[:chain_name] || 'NEAR'

    chain = Chain.find_by(name: chain_name)
    if chain.nil?
      puts "Chain '#{chain_name}' not found"
      exit 1
    end

    puts "Starting sync for chain: #{chain.name}"

    result = SyncTransactionsJob.perform_now(chain.id)

    puts "Sync completed for #{chain.name}!"
    puts "Summary:"
    puts "  - Processed transactions: #{result[:processed] || 'N/A'}"
    puts "  - Errors: #{result[:errors]&.size || 0}"

    if result[:errors]&.any?
      puts "Errors encountered:"
      result[:errors].each { |error| puts "  - #{error}" }
    end
  end

  desc "Show blockchain statistics"
  task stats: :environment do
    puts "Blockchain Statistics"
    puts "=" * 40

    Chain.all.each do |chain|
      puts "\n#{chain.name}:"
      puts "  - Blocks: #{chain.blocks.count}"
      puts "  - Transactions: #{chain.transactions.count}"
             puts "  - Actions: #{chain.transaction_actions.count}"
       puts "  - Transfers: #{chain.transaction_actions.transfers.count}"

      gas_stats = GasCalculatorService.new(chain).gas_statistics
      puts "  - Average Gas: #{gas_stats.average.round(2)}"
      puts "  - Total Gas: #{gas_stats.total}"
    end

    puts "\nOverall Statistics:"
    puts "  - Total Blocks: #{Block.count}"
    puts "  - Total Transactions: #{Transaction.count}"
         puts "  - Total Actions: #{TransactionAction.count}"
     puts "  - Total Transfers: #{TransactionAction.transfers.count}"
  end
end 