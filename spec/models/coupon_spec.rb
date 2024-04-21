require 'rails_helper'

RSpec.describe Coupon, type: :model do
  it {should belong_to :merchant}
  it {should have_many :invoices}
  

  # describe '#validations' do
  #   it { should validate_uniqueness_of :code }
  # end

  describe '#methods' do
    it 'times used' do
      merchant1 = Merchant.create!(name: "Hair Care")

      coupon1 = merchant1.coupons.create!(name: "BOGO50", code: "BOGO50", dollar_off: 50, status: 1)
      coupon2 = merchant1.coupons.create!(name: "Discount10", code: "Discount10", dollar_off: 10, status: 1)
      coupon3 = merchant1.coupons.create!(name: "Discount20", code: "Discount20", dollar_off: 20, status: 1)

      customer_1 = Customer.create!(first_name: "Joey", last_name: "Smith")
      customer_2 = Customer.create!(first_name: "Cecilia", last_name: "Jones")
      customer_3 = Customer.create!(first_name: "Mariah", last_name: "Carrey")
  
      invoice_1 = Invoice.create!(customer_id: customer_1.id, status: 2)
      invoice_2 = Invoice.create!(customer_id: customer_1.id, status: 2)
      invoice_3 = Invoice.create!(customer_id: customer_2.id, status: 2)
      invoice_4 = Invoice.create!(customer_id: customer_3.id, status: 2, coupon_id: coupon1.id)

      transaction1 = Transaction.create!(credit_card_number: 203942, result: 1, invoice_id: invoice_1.id)
      transaction2 = Transaction.create!(credit_card_number: 230948, result: 1, invoice_id: invoice_3.id)
      transaction3 = Transaction.create!(credit_card_number: 234092, result: 1, invoice_id: invoice_4.id)
      transaction74 = Transaction.create!(credit_card_number: 203942, result: 1, invoice_id: invoice_2.id)

      expect(coupon1.times_used).to eq(1)
      expect(coupon2.times_used).to eq(0)
      expect(coupon3.times_used).to eq(0)
    end
  end
end
