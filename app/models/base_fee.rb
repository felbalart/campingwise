class BaseFee < ApplicationRecord
end

# == Schema Information
#
# Table name: base_fees
#
#  id         :bigint(8)        not null, primary key
#  fee_name   :string(255)
#  amount     :decimal(10, )
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
