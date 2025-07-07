class Chain < ApplicationRecord
  has_many :blocks, dependent: :destroy
  has_many :transactions, through: :blocks
  has_many :transaction_actions, through: :transactions

  validates :name, presence: true, uniqueness: true
  validates :api_endpoint, presence: true
  validates :scale_factor, presence: true, numericality: { greater_than: 0 }

  scope :active, -> { where.not(api_endpoint: nil) }

  def formatted_deposit(raw_deposit)
    return 0 if raw_deposit.blank?

    raw_deposit.to_f / (10 ** scale_factor)
  end
end
