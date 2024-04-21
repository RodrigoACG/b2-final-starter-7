require "rails_helper"

RSpec.describe "Coupons index page" do
  before(:each) do
    @merchant1 = Merchant.create!(name: "Hair Care")

    @customer_1 = Customer.create!(first_name: "Joey", last_name: "Smith")
    @customer_2 = Customer.create!(first_name: "Cecilia", last_name: "Jones")
    @customer_3 = Customer.create!(first_name: "Mariah", last_name: "Carrey")

    @invoice_1 = Invoice.create!(customer_id: @customer_1.id, status: 2)
    @invoice_2 = Invoice.create!(customer_id: @customer_1.id, status: 2)
    @invoice_3 = Invoice.create!(customer_id: @customer_2.id, status: 2)
    @invoice_4 = Invoice.create!(customer_id: @customer_3.id, status: 2)

    @item_1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: @merchant1.id)
    @item_2 = Item.create!(name: "Conditioner", description: "This makes your hair shiny", unit_price: 8, merchant_id: @merchant1.id)
    @item_3 = Item.create!(name: "Brush", description: "This takes out tangles", unit_price: 5, merchant_id: @merchant1.id)
    @item_4 = Item.create!(name: "Hair tie", description: "This holds up your hair", unit_price: 1, merchant_id: @merchant1.id)

    @ii_1 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_1.id, quantity: 1, unit_price: 10, status: 0)
    @ii_2 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_2.id, quantity: 1, unit_price: 8, status: 0)
    @ii_3 = InvoiceItem.create!(invoice_id: @invoice_2.id, item_id: @item_3.id, quantity: 1, unit_price: 5, status: 2)
    @ii_4 = InvoiceItem.create!(invoice_id: @invoice_3.id, item_id: @item_4.id, quantity: 1, unit_price: 5, status: 1)
    @ii_5 = InvoiceItem.create!(invoice_id: @invoice_4.id, item_id: @item_4.id, quantity: 1, unit_price: 5, status: 1)

    @transaction1 = Transaction.create!(credit_card_number: 203942, result: 1, invoice_id: @invoice_1.id)
    @transaction2 = Transaction.create!(credit_card_number: 230948, result: 1, invoice_id: @invoice_3.id)
    @transaction3 = Transaction.create!(credit_card_number: 234092, result: 1, invoice_id: @invoice_4.id)
    @transaction74 = Transaction.create!(credit_card_number: 203942, result: 1, invoice_id: @invoice_2.id)

    @coupon1 = @merchant1.coupons.create!(name: "BOGO50", code: "BOGO50", dollar_off: 50, status: 1)
    @coupon2 = @merchant1.coupons.create!(name: "Discount10", code: "Discount10", dollar_off: 10, status: 1)
    @coupon3 = @merchant1.coupons.create!(name: "Discount20", code: "Discount20", dollar_off: 20, status: 1)

  end

  describe '#us 2' do
    it 'creates a new coupon' do

      # When I visit my coupon index page 
      visit merchant_coupons_path(@merchant1)
      # I see a link to create a new coupon.
      expect(page).to have_link("Create Coupon")
      # When I click that link 
      click_on("Create Coupon")
      # I am taken to a new page where I see a form to add a new coupon.
      expect(current_path).to eq(new_merchant_coupon_path(@merchant1))
      # When I fill in that form with a name, unique code, an amount, and whether that amount is a percent or a dollar amount
      fill_in :name, with: "Discount30"
      fill_in :code, with: "Discount30"
      fill_in :dollar_off, with: 30
      # And click the Submit button
      click_on("Submit")
      # I'm taken back to the coupon index page 
      expect(current_path).to eq(merchant_coupons_path(@merchant1))
      # And I can see my new coupon listed.
      expect(page).to have_link("Discount30")
      expect(page).to have_content("Name: Discount30")
    end
  end
end