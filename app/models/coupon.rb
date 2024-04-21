class Coupon < ApplicationRecord
  belongs_to :merchant
  has_many :invoices
  validates :code, uniqueness: true

  enum status: { active: 1, deactive: 0}
  # why am i not able to do it like " 'Active' => 1, 'Deactive' => 0 "
end
