class CouponsController < ApplicationController
  def index 
    @coupons = Coupon.all
  end

  def show 
    @coupon = Coupon.find(params[:id])
  end
  
  def new;end
  
  def create 
    @merchant = Merchant.find(params[:merchant_id])

    if @merchant.coupons.active.length >= 5 
      flash[:alert] = ("Sorry coupon could not be made at this time, The maximum number of coupons (5) has been reached")
    elsif Coupon.exists?(code: coupon_params[:code])
      flash[:alert] = ("Another coupon with this code already exists")
    else 
      @merchant.coupons.create!(coupon_params)
      flash[:alert] = ("Coupon successfully added") 
    end
    
    redirect_to merchant_coupons_path(params[:merchant_id])
  end

 

  def update 
    merchant = Merchant.find(params[:merchant_id])
    # invoice = Invoice.find(params[:invoice_id])

    coupon = Coupon.find(params[:id])
    
    if merchant.invoices.completed
      merchant.coupons.update!(coupon_params)
      flash[:alert] = ("Successfully changed status")
    end

    if merchant.invoices.in_progress
      flash[:alert] = ("Sorry, can't deactivate. Coupon is sill in use")
    end
    redirect_to merchant_coupon_path(merchant, coupon)
  end

  private 

  def coupon_params
    params.permit(:name, :code, :dollar_off, :status, :merchant_id)
  end
end