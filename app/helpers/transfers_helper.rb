module TransfersHelper
  def format_near_amount(raw_amount)
    return "0 NEAR" if raw_amount.blank? || raw_amount.zero?
    
    # Convert from yoctoNEAR (10^24) to NEAR
    near_amount = raw_amount.to_f / (10 ** 24)
    
    if near_amount >= 1
      "#{number_with_precision(near_amount, precision: 4, strip_insignificant_zeros: true)} NEAR"
    else
      "#{number_with_precision(near_amount, precision: 8, strip_insignificant_zeros: true)} NEAR"
    end
  end
  
  def format_transaction_hash(hash)
    return "N/A" if hash.blank?
    
    "#{hash[0..6]}...#{hash[-6..-1]}"
  end
  
  def format_address(address)
    return "N/A" if address.blank?
    
    if address.length > 20
      "#{address[0..8]}...#{address[-8..-1]}"
    else
      address
    end
  end
  
  def gas_color_class(gas_amount)
    return "text-gray-500" if gas_amount.blank?
    
    case gas_amount
    when 0..1_000_000
      "text-green-600"
    when 1_000_000..10_000_000
      "text-yellow-600"
    else
      "text-red-600"
    end
  end
end
