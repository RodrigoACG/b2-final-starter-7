require "rails_helper"

describe "Admin Invoices Index Page" do
  before :each do
    @m1 = Merchant.create!(name: "Merchant 1")

    @c1 = Customer.create!(first_name: "Yo", last_name: "Yoz", address: "123 Heyyo", city: "Whoville", state: "CO", zip: 12345)
    @c2 = Customer.create!(first_name: "Hey", last_name: "Heyz")

    @i1 = Invoice.create!(customer_id: @c1.id, status: 2, created_at: "2012-03-25 09:54:09")
    @i2 = Invoice.create!(customer_id: @c2.id, status: 1, created_at: "2012-03-25 09:30:09")

    @item_1 = Item.create!(name: "test", description: "lalala", unit_price: 6, merchant_id: @m1.id)
    @item_2 = Item.create!(name: "rest", description: "dont test me", unit_price: 12, merchant_id: @m1.id)

    @ii_1 = InvoiceItem.create!(invoice_id: @i1.id, item_id: @item_1.id, quantity: 12, unit_price: 2, status: 0)
    @ii_2 = InvoiceItem.create!(invoice_id: @i1.id, item_id: @item_2.id, quantity: 6, unit_price: 1, status: 1)
    @ii_3 = InvoiceItem.create!(invoice_id: @i2.id, item_id: @item_2.id, quantity: 87, unit_price: 12, status: 2)

  end
  
  it "should display the id, status and created_at" do
    visit admin_invoice_path(@i1)
    expect(page).to have_content("Invoice ##{@i1.id}")
    expect(page).to have_content("Created on: #{@i1.created_at.strftime("%A, %B %d, %Y")}")
    
    expect(page).to_not have_content("Invoice ##{@i2.id}")
  end
  
  it "should display the customers name and shipping address" do
    visit admin_invoice_path(@i1)
    expect(page).to have_content("#{@c1.first_name} #{@c1.last_name}")
    expect(page).to have_content(@c1.address)
    expect(page).to have_content("#{@c1.city}, #{@c1.state} #{@c1.zip}")
    
    expect(page).to_not have_content("#{@c2.first_name} #{@c2.last_name}")
  end
  
  it "should display all the items on the invoice" do
    visit admin_invoice_path(@i1)
    expect(page).to have_content(@item_1.name)
    expect(page).to have_content(@item_2.name)
    
    expect(page).to have_content(@ii_1.quantity)
    expect(page).to have_content(@ii_2.quantity)
    
    expect(page).to have_content("$#{@ii_1.unit_price}")
    expect(page).to have_content("$#{@ii_2.unit_price}")
    
    expect(page).to have_content(@ii_1.status)
    expect(page).to have_content(@ii_2.status)
    
    expect(page).to_not have_content(@ii_3.quantity)
    expect(page).to_not have_content("$#{@ii_3.unit_price}")
    expect(page).to_not have_content(@ii_3.status)
  end
  
  it "should display the total revenue the invoice will generate" do
    visit admin_invoice_path(@i1)
    expect(page).to have_content("Total Revenue: $#{@i1.total_revenue}")
    
    expect(page).to_not have_content(@i2.total_revenue)
  end
  
  it "should have status as a select field that updates the invoices status" do
    visit admin_invoice_path(@i1)
    within("#status-update-#{@i1.id}") do
    select("cancelled", :from => "invoice[status]")
    expect(page).to have_button("Update Invoice")
    click_button "Update Invoice"
    
    expect(current_path).to eq(admin_invoice_path(@i1))
    expect(@i1.status).to eq("completed")
  end
end

describe '#us8' do
it 'displays the name and code of the coupon that was used ' do
      merchant1 = Merchant.create!(name: "Hair Care")
      
      customer_1 = Customer.create!(first_name: "Joey", last_name: "Smith")
      
      coupon1 = merchant1.coupons.create!(name: "BOGO50", code: "BOGO50", dollar_off: 50, status: 1)
      coupon2 = merchant1.coupons.create!(name: "Discount10", code: "Discount10", dollar_off: 10, status: 1)
      coupon3 = merchant1.coupons.create!(name: "Discount20", code: "Discount20", dollar_off: 20, status: 1)
      
      invoice_1 = Invoice.create!(customer_id: customer_1.id, status: 2, coupon_id: coupon2.id)
      invoice_2 = Invoice.create!(customer_id: customer_1.id, status: 2, coupon_id: coupon3.id)
      
      
      item_1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: merchant1.id)
      item_2 = Item.create!(name: "Conditioner", description: "This makes your hair shiny", unit_price: 8, merchant_id: merchant1.id)
      item_3 = Item.create!(name: "Brush", description: "This takes out tangles", unit_price: 5, merchant_id: merchant1.id)
      
      ii_1 = InvoiceItem.create!(invoice_id: invoice_1.id, item_id: item_1.id, quantity: 2, unit_price: 10, status: 2)
      ii_2 = InvoiceItem.create!(invoice_id: invoice_1.id, item_id: item_2.id, quantity: 1, unit_price: 8, status: 2)
      ii_3 = InvoiceItem.create!(invoice_id: invoice_2.id, item_id: item_3.id, quantity: 1, unit_price: 5, status: 2)
      
      
      transaction1 = Transaction.create!(credit_card_number: 203942, result: 1, invoice_id: invoice_1.id)
      transaction74 = Transaction.create!(credit_card_number: 203942, result: 1, invoice_id: invoice_2.id)
      
      # When I visit one of my admin invoice show pages
      visit admin_invoice_path(invoice_1.id)

      # I see the name and code of the coupon that was used (if there was a coupon applied)
      expect(page).to have_content("Coupon Name: Discount10")
      expect(page).to have_content("Coupon Code: Discount10")

      expect(page).to have_content("Subtotal: $28")
      # And I see both the subtotal revenue from that invoice (before coupon) and the grand total revenue (after coupon) for this invoice.

      expect(page).to have_content("Grand Total: $18")


      
    end
    
    # it "alternate path1" do 
    #   merchant1 = Merchant.create(name: "Hair Care")
    #   merchant2 = Merchant.create(name: "Face Care")

    #   coupon1 = merchant1.coupons.create(name: "BOGO50", code: "BOGO50", dollar_off: 50, status: :active)
    #   coupon2 = merchant2.coupons.create(name: "Discount15", code: "Discount15", dollar_off: 15, status: :active)

    #   customer = Customer.create(first_name: "Joey", last_name: "Smith")

    #   item1 = Item.create(name: "Shampoo", unit_price: 10, merchant: merchant1)
    #   item2 = Item.create(name: "Conditioner", unit_price: 8, merchant: merchant2)
    #   item3 = Item.create(name: "Gel", unit_price: 9, merchant: merchant2)

    #   invoice1 = Invoice.create(customer: customer, status: :completed, coupon: coupon1)
    #   invoice2 = Invoice.create(customer: customer, status: :completed, coupon: coupon2)

    #   InvoiceItem.create(invoice: invoice1, item: item1, quantity: 2, unit_price: 10, status: 1)
    #   InvoiceItem.create(invoice: invoice1, item: item2, quantity: 1, unit_price: 8, status: 1)
    #   InvoiceItem.create(invoice: invoice2, item: item3, quantity: 1, unit_price: 9, status: 1)

    #   visit admin_invoice_path(invoice1.id)
      
    #   expect(page).to have_content("Subtotal: $28")
      
    #   expect(page).to have_content("Grand Total: $8")
      
      
    # end
    
    it "alternate path2" do 
      # 2. When a coupon with a dollar-off value is used with an invoice with multiple merchants' items, the dollar-off amount applies to the total amount even though there may be items present from another merchant.

      merchant1 = Merchant.create!(name: "Hair Care")
      merchant2 = Merchant.create!(name: "Face Care")

      
      customer_1 = Customer.create!(first_name: "Joey", last_name: "Smith")
      
      coupon1 = merchant1.coupons.create!(name: "BOGO50", code: "BOGO50", dollar_off: 50, status: 1)
      coupon2 = merchant1.coupons.create!(name: "Discount10", code: "Discount10", dollar_off: 10, status: 1)
      coupon3 = merchant1.coupons.create!(name: "Discount20", code: "Discount20", dollar_off: 20, status: 1)

      coupon4 = merchant2.coupons.create!(name: "Discount15", code: "Discount15", dollar_off: 15, status: 1)
      coupon5 = merchant2.coupons.create!(name: "Discount30", code: "Discount30", dollar_off: 30, status: 1)
      
      invoice_1 = Invoice.create!(customer_id: customer_1.id, status: 2, coupon_id: coupon1.id)
      invoice_2 = Invoice.create!(customer_id: customer_1.id, status: 2, coupon_id: coupon3.id)
      
      
      item_1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: merchant1.id)
      item_2 = Item.create!(name: "Conditioner", description: "This makes your hair shiny", unit_price: 8, merchant_id: merchant1.id)
      item_3 = Item.create!(name: "Brush", description: "This takes out tangles", unit_price: 5, merchant_id: merchant1.id)
      item_4 = Item.create!(name: "Gel", description: "This makes your haior stay", unit_price: 9, merchant_id: merchant2.id)
      item_5 = Item.create!(name: "Clippers", description: "This cuts your hair", unit_price: 100, merchant_id: merchant2.id)
      
      ii_1 = InvoiceItem.create!(invoice_id: invoice_1.id, item_id: item_1.id, quantity: 2, unit_price: 10, status: 2)
      ii_2 = InvoiceItem.create!(invoice_id: invoice_1.id, item_id: item_2.id, quantity: 1, unit_price: 8, status: 2)
      ii_3 = InvoiceItem.create!(invoice_id: invoice_2.id, item_id: item_3.id, quantity: 1, unit_price: 5, status: 2)
      ii_3 = InvoiceItem.create!(invoice_id: invoice_1.id, item_id: item_4.id, quantity: 1, unit_price: 9, status: 2)
      ii_3 = InvoiceItem.create!(invoice_id: invoice_1.id, item_id: item_5.id, quantity: 1, unit_price: 100, status: 2)
      
      
      transaction1 = Transaction.create!(credit_card_number: 203942, result: 1, invoice_id: invoice_1.id)
      transaction74 = Transaction.create!(credit_card_number: 203942, result: 1, invoice_id: invoice_2.id)

      visit admin_invoice_path(invoice_1.id)
      
      expect(page).to have_content("Subtotal: $137")
      
      expect(page).to have_content("Grand Total: $87")


    end
  end
end
