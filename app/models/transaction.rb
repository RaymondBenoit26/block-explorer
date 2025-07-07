class Transaction < ApplicationRecord
  belongs_to :block
  has_many :transaction_actions, dependent: :destroy

  validates :transaction_hash, presence: true, uniqueness: true
  validates :gas_burnt, presence: true, numericality: { greater_than_or_equal_to: 0 }

  scope :with_gas, -> { where.not(gas_burnt: nil) }
  scope :recent, -> { joins(:block).order("blocks.height DESC") }

  delegate :chain, to: :block

  has_many :transfer_actions, -> { where(action_type: "transfer") }, class_name: "TransactionAction"

  def has_transfers?
    transfer_actions.exists?
  end
end
