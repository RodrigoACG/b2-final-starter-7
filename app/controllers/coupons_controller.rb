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

    if Coupon.exists?(code: coupon_params[:code]) 
      flash[:alert] = ("Another coupon with this code already exists")
    elsif @merchant.coupons.active.count >= 5 
      flash[:alert] = ("Sorry coupon could not be made at this time, The maximum number of coupons (5) has been reached")
    else @merchant.coupons.active
      @merchant.coupons.create!(coupon_params)
      flash[:alert] = ("Coupon successfully added") 
    end

    redirect_to merchant_coupons_path(params[:merchant_id])

  end


  def update
    merchant = Merchant.find(params[:merchant_id])

    coupon = Coupon.find(params[:id])


    if coupon.status == "inactive"
      coupon.update(status: :active)
      flash[:notice] = ("Coupon activated successfully.")
  
    else coupon.status == "active" 
      coupon.update(status: :inactive)
      flash[:notice] = 'Coupon deactivated successfully.'
    end
    
    if coupon.times_used >= 1

      flash[:notice] = ("Sorry, can't deactivate. Coupon is sill in use")
    end

    redirect_to merchant_coupon_path(merchant, coupon)

  end

  private 

  def coupon_params
    params.permit(:name, :code, :dollar_off, :status, :merchant_id)
  end
end