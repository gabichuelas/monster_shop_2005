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
      @order_1 = user.orders.create!(name: 'Meg', address: '123 Stang St', city: 'Hershey', state: 'PA', zip: 80218)
      @item_order = @order_1.item_orders.create!(item: @chain, price: @chain.price, quantity: 2)
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
  end
end
