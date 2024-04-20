class DashboardController < ApplicationController
  def index
    @merchant = Merchant.find(params[:merchant_id])
    @coupons = Coupon.all

  end
end
