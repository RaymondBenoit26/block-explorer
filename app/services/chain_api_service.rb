class ChainApiService
  include HTTParty

  attr_reader :chain, :base_uri, :api_key

  def initialize(chain)
    @chain = chain
    @base_uri = chain.api_endpoint
    @api_key = chain.api_key
    self.class.base_uri(@base_uri)
  end

  def fetch_transactions
    options = {
      headers: {
        "Content-Type" => "application/json",
        "User-Agent" => "BlockExplorer/1.0"
      }
    }

    options[:query] = { api_key: @api_key } if @api_key.present?

    response = self.class.get("", options)

    if response.success?
      response.parsed_response
    else
      raise ApiError, "Failed to fetch transactions: #{response.code} - #{response.message}"
    end
  rescue StandardError => e
    raise ApiError, "Error fetching transactions: #{e.message}"
  end

  class ApiError < StandardError; end
end
