require "rails_helper"

RSpec.describe "Coupons show page" do
  before(:each) do 
    @merchant1 = Merchant.create!(name: "Hair Care")

    @coupon1 = @merchant1.coupons.create!(name: "BOGO50", code: "BOGO50", dollar_off: 50, status: 1)
    @coupon2 = @merchant1.coupons.create!(name: "Discount10", code: "Discount10", dollar_off: 10, status: 1)
    @coupon3 = @merchant1.coupons.create!(name: "Discount20", code: "Discount20", dollar_off: 20, status: 1)
    @coupon4 = @merchant1.coupons.create!(name: "Discount30", code: "Discount30", dollar_off: 30, status: 0)

    @customer_1 = Customer.create!(first_name: "Joey", last_name: "Smith")
    @customer_2 = Customer.create!(first_name: "Cecilia", last_name: "Jones")
    @customer_3 = Customer.create!(first_name: "Mariah", last_name: "Carrey")

    @invoice_1 = Invoice.create!(customer_id: @customer_1.id, status: 2)
    @invoice_2 = Invoice.create!(customer_id: @customer_1.id, status: 1, coupon_id: @coupon2.id)
    @invoice_3 = Invoice.create!(customer_id: @customer_2.id, status: 2, coupon_id: @coupon1.id)
    @invoice_4 = Invoice.create!(customer_id: @customer_3.id, status: 2, coupon_id: @coupon1.id)

    @item_1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: @merchant1.id)
    @item_2 = Item.create!(name: "Conditioner", description: "This makes your hair shiny", unit_price: 8, merchant_id: @merchant1.id)
    @item_3 = Item.create!(name: "Brush", description: "This takes out tangles", unit_price: 5, merchant_id: @merchant1.id)
    @item_4 = Item.create!(name: "Hair tie", description: "This holds up your hair", unit_price: 1, merchant_id: @merchant1.id)

    @ii_1 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_1.id, quantity: 1, unit_price: 10, status: 2)
    @ii_2 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_2.id, quantity: 1, unit_price: 8, status: 2)
    @ii_3 = InvoiceItem.create!(invoice_id: @invoice_2.id, item_id: @item_3.id, quantity: 1, unit_price: 5, status: 2)
    @ii_4 = InvoiceItem.create!(invoice_id: @invoice_3.id, item_id: @item_4.id, quantity: 1, unit_price: 5, status: 0)
    @ii_5 = InvoiceItem.create!(invoice_id: @invoice_4.id, item_id: @item_4.id, quantity: 1, unit_price: 5, status: 0)

    @transaction1 = Transaction.create!(credit_card_number: 203942, result: 1, invoice_id: @invoice_1.id)
    @transaction2 = Transaction.create!(credit_card_number: 230948, result: 1, invoice_id: @invoice_3.id)
    @transaction3 = Transaction.create!(credit_card_number: 234092, result: 1, invoice_id: @invoice_4.id)
    @transaction74 = Transaction.create!(credit_card_number: 203942, result: 1, invoice_id: @invoice_2.id)
  end

  describe '#us 3' do
    it 'sees how many times that coupon has been used' do
      # When I visit a merchant's coupon show page 
      visit merchant_coupon_path(@merchant1, @coupon1)
      # I see that coupon's name and code 
      within '.section' do
        expect(page).to have_content("Name: BOGO50")
        expect(page).to have_content("Code: BOGO50")
        expect(page).to have_content("Amount off: 50")
        # And I see the percent/dollar off value
        expect(page).to have_content("Status: active")
        # And I see a count of how many times that coupon has been used.
        
        expect(page).to have_content("Times used: 2")
      end
      # As well as its status (active or inactive)
      # save_and_open_page

      # (Note: "use" of a coupon should be limited to successful transactions.)
    end
  end

  describe '#us 4' do
    it 'shows button deactivate' do
      
      # When I visit one of my active coupon's show pages
      visit merchant_coupon_path(@merchant1, @coupon1)
      # I see a button to deactivate that coupon
      expect(page).to have_button("Deactivate #{@coupon1.name}")
      click_on("Deactivate #{@coupon1.name}")
      
      # When I click that button
      save_and_open_page
      # I'm taken back to the coupon show page 
      expect(current_path).to eq(merchant_coupon_path(@merchant1, @coupon1))
      
      expect(page).to have_button("Activate #{@coupon1.name}")
      expect(page).to have_content("Status: inactive")
      # And I can see that its status is now listed as 'inactive'.
      
      # expect(page).to have_content("Status: Inactive")
    end
    
    it "sad path" do 
      # A coupon cannot be deactivated if there are any pending invoices with that coupon
      
      visit merchant_coupon_path(@merchant1, @coupon2)
      expect(page).to have_button("Deactivate #{@coupon2.name}")
      click_on("Deactivate #{@coupon2.name}")
      
      expect(current_path).to eq(merchant_coupon_path(@merchant1, @coupon2))
      
      expect(page).to have_content("Sorry, can't deactivate. Coupon is sill in use")
      # save_and_open_page
    end
  end

  describe '#us 5' do
    it 'Shows button to activate' do
      # When I visit one of my inactive coupon show pages
      visit merchant_coupon_path(@merchant1, @coupon4)
      # I see a button to activate that coupon
      expect(page).to have_button("Activate #{@coupon4.name}")
      # When I click that button
      click_on("Activate #{@coupon4.name}")
      # I'm taken back to the coupon show page 
      expect(current_path).to eq(merchant_coupon_path(@merchant1, @coupon4))
      
      # And I can see that its status is now listed as 'active'
      expect(page).to have_button("Deactivate #{@coupon4.name}")
      expect(page).to have_content("Status: active")

    end
  end
end