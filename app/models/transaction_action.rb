class TransactionAction < ApplicationRecord
  self.table_name = "actions"

  belongs_to :txn, class_name: "Transaction", foreign_key: "transaction_id"

  validates :action_type, presence: true
  validates :deposit, presence: true, numericality: { greater_than_or_equal_to: 0 }

  scope :transfers, -> { where(action_type: ["transfer", "functioncall"]).where("deposit > 0 OR action_type = ?", "transfer") }
  scope :recent, -> { joins(:txn => :block).order("blocks.height DESC") }

  def chain
    txn.block.chain
  end

  def transaction
    txn
  end

  def formatted_deposit
    return 0 if deposit.blank?

    chain.formatted_deposit(deposit)
  end

  def formatted_deposit_with_symbol
    "#{formatted_deposit} #{chain.name.upcase}"
  end
end
