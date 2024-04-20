class Coupon < ApplicationRecord
  belongs_to :merchant

  enum status: {"Active" => 1, "Deactive" => 0}
end
