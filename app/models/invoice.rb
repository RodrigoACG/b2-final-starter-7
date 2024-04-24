class Invoice < ApplicationRecord
  validates_presence_of :status,
                        :customer_id

  belongs_to :customer
  has_many :transactions
  has_many :invoice_items
  has_many :items, through: :invoice_items
  has_many :merchants, through: :items
  belongs_to :coupon, optional: true

  enum status: {cancelled: 0, in_progress: 1, completed: 2}

  def total_revenue
    invoice_items.sum("unit_price * quantity")
  end

  
  def grand_total 
    total_revenue - discount
  end
  
  def discount
     coupon_discount = Coupon.where(id: coupon_id).pluck(:dollar_off).first || 0 
    #  In this one we are fiding a coupon that matched that id and then we are only wanting the dollar_off. we used the .first becasue its like saying Give me the first dollar-off value you find, or if you don't find any, just give me zero
     coupon_discount > total_revenue ? total_revenue : coupon_discount
    #   then this part we are comparing the dollar_off amount and the total_revenue  and if the coupondiscount is greater then the total revenue we will just say the coupon amount is the same as the total revenue but if not we will just use the discount amount how it is.
  end
end
