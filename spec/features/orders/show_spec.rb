RSpec.describe 'As a registered user' do
  describe 'When I visit my Profile Orders page; And I click on a link for order\'s show page' do

    before :each do
      user = User.create!(name: "Jackie Vance",
                                    address: "123 ABC St.",
                                    city: "Denver",
                                    state: "CO",
                                    zip: "80202",
                                    email: "jackie@hotmail.com",
                                    password: "qwer",
                                    role: 0)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

      bike_shop = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @chain = bike_shop.items.create(name: "Chain", description: "It'll never break!", price: 50, image: "https://www.rei.com/media/b61d1379-ec0e-4760-9247-57ef971af0ad?size=784x588", inventory: 5)
      @tire = bike_shop.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)

      @order_1 = user.orders.create!(name: 'Meg', address: '123 Stang St', city: 'Hershey', state: 'PA', zip: 80218)
      @order_2 = user.orders.create!(name: 'Cory', address: '567 Up St', city: 'Mars', state: 'CO', zip: 80218)

      @item_order = @order_1.item_orders.create!(item: @chain, price: @chain.price, quantity: 2, status: 0)
      @item_order2 = @order_1.item_orders.create!(item: @tire, price: @tire.price, quantity: 1, status: 1)
      @item_order3 = @order_2.item_orders.create!(item: @chain, price: @chain.price, quantity: 2, status: 0)
      @item_order4 = @order_2.item_orders.create!(item: @tire, price: @tire.price, quantity: 1, status: 0)
    end

    it 'My URL route is now something like "/profile/orders/15";' do

      visit "/profile/orders"
      click_on "Order ID: #{@order_1.id}"
      expect(current_path).to eq("/profile/orders/#{@order_1.id}")
    end

    it 'I see all information about the order, including the following information: ID, date created and updated, current status, each item ordered (incl. name, description, thumbnail, qty, price, and subtotal), total qty of items in order, and grand total of order' do

      visit "/profile/orders/#{@order_1.id}"

      expect(page).to have_content(@order_1.id)
      expect(page).to have_content(@order_1.created_at)
      expect(page).to have_content(@order_1.updated_at)
      expect(page).to have_content(@order_1.status)

      within("#item-#{@chain.id}") do
        expect(page).to have_xpath("//img[@src = 'https://www.rei.com/media/b61d1379-ec0e-4760-9247-57ef971af0ad?size=784x588']")
        expect(page).to have_content(@chain.name)
        expect(page).to have_content(@chain.description)
        expect(page).to have_content(@item_order.quantity)
        expect(page).to have_content(@item_order.price)
        expect(page).to have_content(@item_order.subtotal)
      end

      expect(page).to have_content(@order_1.total_quantity)
      expect(page).to have_content(@order_1.grandtotal)
    end


    it 'I see a button or link to cancel the order' do

      visit "/profile/orders/#{@order_1.id}"
      expect(page).to have_link('Cancel Order')
    end

    it 'When I click the cancel button for an order, the following happens:
    - Each row in the "order items" table is given a status of "unfulfilled"
    - The order itself is given a status of "cancelled"
    - Any item quantities in the order that were previously fulfilled have their quantities returned to their respective merchant\'s inventory for that item.
    - I am returned to my profile page
    - I see a flash message telling me the order is now cancelled
    - And I see that this order now has an updated status of "cancelled"' do

      visit "/profile/orders/#{@order_1.id}"
      click_on 'Cancel Order'

      expect(current_path).to eq("/profile/orders")
      expect(page).to have_content('Your order is now cancelled')
      expect(@order_1.status).to eq('cancelled')
      expect(@item_order.status).to eq('unfulfilled')
      expect(@item_order.quantity + @chain.inventory).to eq(7)
    end
  end
end
