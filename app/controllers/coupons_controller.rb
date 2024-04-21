class CouponsController < ApplicationController
  def index 
    @coupons = Coupon.all
  end

  def show 
    @coupon = Coupon.find(params[:id])
  end

  def new;end

  def create 
   Coupon.create!(coupon_params)
   redirect_to merchant_coupons_path(params[:merchant_id])
  end

  private 

  def coupon_params
    params.permit(:name, :code, :dollar_off, :status, :merchant_id)
  end
end