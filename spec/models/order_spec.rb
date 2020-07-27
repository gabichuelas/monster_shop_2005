require 'rails_helper'

describe Order, type: :model do
  describe "validations" do
    it { should validate_presence_of :name }
    it { should validate_presence_of :address }
    it { should validate_presence_of :city }
    it { should validate_presence_of :state }
    it { should validate_presence_of :zip }
  end

  describe "relationships" do
    it {should belong_to :user}
    it {should have_many :item_orders}
    it {should have_many(:items).through(:item_orders)}
  end

  describe 'instance methods' do
    before :each do
      @user = User.create!(name: "Bob Vance",
                                    address: "123 ABC St.",
                                    city: "Denver",
                                    state: "CO",
                                    zip: "80202",
                                    email: "example@hotmail.com",
                                    password: "qwer",
                                    role: 0)

      @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @brian = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)

      @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      @pull_toy = @brian.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)

      @order_1 = @user.orders.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033)

      @order_1.item_orders.create!(item: @tire, price: @tire.price, quantity: 2)
      @order_1.item_orders.create!(item: @pull_toy, price: @pull_toy.price, quantity: 3)
    end
    it 'grandtotal' do
      expect(@order_1.grandtotal).to eq(230)
    end

    it 'total_items' do
      jack = Merchant.create!(name: "Jack's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      bob = Merchant.create!(name: "Bob's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)

      employee1 = User.create!(name: "Bill Nye", address: "Wilmur Lane", city: "Denver", state: "Colorado", zip: "80202", email: "example_merchant_employee@hotmail.com", password: "qwer", role: 1, merchant_id: jack.id)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(employee1)

      user7 = User.create!(name: "Jake", address: "1234 DEF St.", city: "Denver", state: "Colorado", zip: "80202", email: "example2@hotmail.com", password: "qwer", role: 0)

      tire = jack.items.create!(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      chain = jack.items.create!(name: "Chain", description: "It'll never break!", price: 50, image: "https://www.rei.com/media/b61d1379-ec0e-4760-9247-57ef971af0ad?size=784x588", inventory: 5)
      dog_bone = bob.items.create!(name: "Dog Bone", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", inventory: 21)

      order_9 = user7.orders.create!(name: 'Melvin', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033, status: "pending")
      order_10 = user7.orders.create!(name: 'Jackie', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033, status: "shipped")

      order_9.item_orders.create!(item: tire, price: tire.price, quantity: 1)
      order_9.item_orders.create!(item: chain, price: chain.price, quantity: 2)
      order_9.item_orders.create!(item: dog_bone, price: dog_bone.price, quantity: 2)

      order_10.item_orders.create!(item: tire, price: tire.price, quantity: 1)
      order_10.item_orders.create!(item: chain, price: chain.price, quantity: 3)
      order_10.item_orders.create!(item: dog_bone, price: dog_bone.price, quantity: 2)

      expect(order_9.total_items(jack)).to eq(3)
    end
  end
end
