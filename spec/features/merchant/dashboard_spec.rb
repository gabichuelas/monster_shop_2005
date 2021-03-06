require 'rails_helper'

RSpec.describe "Merchant dashboard" do
  before(:each) do

    @user1 = User.create!(name: "Bob Vance", address: "123 ABC St.", city: "Denver", state: "Colorado", zip: "80202", email: "example@hotmail.com", password: "qwer", role: 0)
    @user2 = User.create!(name: "Jake", address: "1234 DEF St.", city: "Denver", state: "Colorado", zip: "80202", email: "example2@hotmail.com", password: "qwer", role: 0)
    @user3 = User.create!(name: "Jackie", address: "567 Ghi St.", city: "Denver", state: "Colorado", zip: "80202", email: "example3@hotmail.com", password: "qwer", role: 0)
    @user4 = User.create!(name: "Jose", address: "789 Jkl St.", city: "Denver", state: "Colorado", zip: "80202", email: "example4@hotmail.com", password: "qwer", role: 0)

    @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
    @brian = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)

    @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
    @chain = @meg.items.create(name: "Chain", description: "It'll never break!", price: 50, image: "https://www.rei.com/media/b61d1379-ec0e-4760-9247-57ef971af0ad?size=784x588", inventory: 5)
    @pull_toy = @brian.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
    @dog_bone = @brian.items.create(name: "Dog Bone", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", inventory: 21)

    @order_1 = @user1.orders.create!(name: 'Bob Vance', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033, status: "shipped")
    @order_2 = @user2.orders.create!(name: 'Jake', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033, status: "pending")
    @order_3 = @user3.orders.create!(name: 'Jackie', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033, status: "packaged")
    @order_4 = @user4.orders.create!(name: 'Jose', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033, status: "shipped")
    @order_5 = @user2.orders.create!(name: 'Bob Vance', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033, status: "cancelled")


    @order_1.item_orders.create!(item: @tire, price: @tire.price, quantity: 2)
    @order_1.item_orders.create!(item: @pull_toy, price: @pull_toy.price, quantity: 3)
    @order_2.item_orders.create!(item: @tire, price: @tire.price, quantity: 1)
    @order_2.item_orders.create!(item: @chain, price: @chain.price, quantity: 2)
    @order_2.item_orders.create!(item: @dog_bone, price: @dog_bone.price, quantity: 2)
    @order_3.item_orders.create!(item: @dog_bone, price: @dog_bone.price, quantity: 2)
    @order_4.item_orders.create!(item: @tire, price: @tire.price, quantity: 2)
    @order_5.item_orders.create!(item: @pull_toy, price: @pull_toy.price, quantity: 1)

    @employee = User.create!(name: "Bill Nye",
                                  address: "Wilmur Lane",
                                  city: "Denver",
                                  state: "Colorado",
                                  zip: "80202",
                                  email: "example_merchant_employee@hotmail.com",
                                  password: "qwer",
                                  role: 1,
                                  merchant_id: @meg.id)

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@employee)
  end

  describe "When I visit my merchant dashboard" do
    it "I see the name and full address of the merchant I work for" do
      visit "/merchant"

      within '#merchant-info' do
        expect(page).to have_content(@meg.name)
        expect(page).to have_content(@meg.address)
        expect(page).to have_content(@meg.city)
        expect(page).to have_content(@meg.state)
        expect(page).to have_content(@meg.zip)
      end
    end

    it "if any users have pending orders containing items I sell then I see a list of these orders. Each order listed includes:
      - the ID of the order, which is a link to the order show page /merchant/orders/15
      - the date the order was made
      - the total quantity of my items in the order
      - the total value of my items for that order" do

      visit "/merchant"

      within '.orders' do
        expect(page).to have_link("#{@order_2.id}")
        expect(page).to have_content("Date Created: #{@order_2.created_at}")
        expect(page).to have_content("Number of items in this order: 3")
        expect(page).to have_content("Total Value: $200")
      end

      within '.orders' do
        click_on "#{@order_2.id}"
      end

      expect(current_path).to eq("/merchant/orders/#{@order_2.id}")
    end
  end
end
