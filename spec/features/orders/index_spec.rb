RSpec.describe 'As a registered user' do
  describe 'When I visit my' do

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
      chain = bike_shop.items.create(name: "Chain", description: "It'll never break!", price: 50, image: "https://www.rei.com/media/b61d1379-ec0e-4760-9247-57ef971af0ad?size=784x588", inventory: 5)
      @order_1 = user.orders.create!(name: 'Meg', address: '123 Stang St', city: 'Hershey', state: 'PA', zip: 80218)
      @order_1.item_orders.create!(item: chain, price: chain.price, quantity: 2)
    end

    it 'When I visit my Profile Orders page (/profile/orders), I see every order I\'ve made, which includes: order id, which is a link to the order show page, date created, date updated, current status, total qty, grand total' do

      visit "/profile/orders"

      expect(page).to have_content("Order ID: #{@order_1.id}")
      expect(page).to have_content("Order Created At: #{@order_1.created_at}")
      expect(page).to have_content("Order Updated At: #{@order_1.updated_at}")
      expect(page).to have_content(@order_1.status)
      expect(page).to have_content("Items in Order: #{@order_1.total_quantity}")
    end
  end
end
