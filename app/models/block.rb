class Block < ApplicationRecord
  belongs_to :chain
  has_many :transactions, dependent: :destroy
  has_many :transaction_actions, through: :transactions

  validates :height, presence: true, uniqueness: { scope: :chain_id }
  validates :block_hash, presence: true, uniqueness: true

  scope :by_height, -> { order(:height) }
  scope :recent, -> { order(height: :desc) }

  has_many :transfer_actions, -> { where(action_type: "transfer") }, class_name: "TransactionAction"
end
