class Coupon < ApplicationRecord
  belongs_to :merchant
  has_many :invoices

  enum status: {"Active" => 1, "Deactive" => 0}
end
