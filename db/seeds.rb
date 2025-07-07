# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Create NEAR blockchain chain
Chain.find_or_create_by(name: 'NEAR') do |chain|
  chain.api_endpoint = 'https://4816b0d3-d97d-47c4-a02c-298a5081c0f9.mock.pstmn.io/near/transactions'
  chain.api_key = 'SECRET_API_KEY'
  chain.scale_factor = 24 # NEAR token has 24 decimal places
end

puts "✅ NEAR chain initialized"
