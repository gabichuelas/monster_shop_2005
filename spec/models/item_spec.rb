require 'rails_helper'

describe Item, type: :model do
  describe "validations" do
    it { should validate_presence_of :name }
    it { should validate_presence_of :description }
    it { should validate_presence_of :price }
    # it { should validate_presence_of :image }
    it { should validate_presence_of :inventory }
    it { should validate_inclusion_of(:active?).in_array([true,false]) }
  end

  describe "relationships" do
    it {should belong_to :merchant}
    it {should have_many :reviews}
    it {should have_many :item_orders}
    it {should have_many(:orders).through(:item_orders)}
  end

  describe "instance methods" do
    before(:each) do
      @bike_shop = Merchant.create(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @chain = @bike_shop.items.create(name: "Chain", description: "It'll never break!", price: 50, image: "https://www.rei.com/media/b61d1379-ec0e-4760-9247-57ef971af0ad?size=784x588", inventory: 5)

      @review_1 = @chain.reviews.create(title: "Great place!", content: "They have great bike stuff and I'd recommend them to anyone.", rating: 5)
      @review_2 = @chain.reviews.create(title: "Cool shop!", content: "They have cool bike stuff and I'd recommend them to anyone.", rating: 4)
      @review_3 = @chain.reviews.create(title: "Meh place", content: "They have meh bike stuff and I probably won't come back", rating: 1)
      @review_4 = @chain.reviews.create(title: "Not too impressed", content: "v basic bike shop", rating: 2)
      @review_5 = @chain.reviews.create(title: "Okay place :/", content: "Brian's cool and all but just an okay selection of items", rating: 3)
    end

    it "calculate average review" do
      expect(@chain.average_review).to eq(3.0)
    end

    it "sorts reviews" do
      top_three = @chain.sorted_reviews(3,:desc)
      bottom_three = @chain.sorted_reviews(3,:asc)

      expect(top_three).to eq([@review_1,@review_2,@review_5])
      expect(bottom_three).to eq([@review_3,@review_4,@review_5])
    end

    it 'no orders' do
      user = User.create!(name: "Bob Vance",
                                    address: "123 ABC St.",
                                    city: "Denver",
                                    state: "CO",
                                    zip: "80202",
                                    email: "example@hotmail.com",
                                    password: "qwer",
                                    role: 0)

      expect(@chain.no_orders?).to eq(true)
      order = user.orders.create(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033)
      order.item_orders.create(item: @chain, price: @chain.price, quantity: 2)
      expect(@chain.no_orders?).to eq(false)
    end
  end

  describe "class methods" do
    before(:each) do
      @existing_user = User.create!(name: "Bob Vance", address: "123 ABC St.", city: "Denver", state: "Colorado", zip: "80202", email: "example@hotmail.com", password: "qwer", role: 0)

      @meg = Merchant.create!(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @brian = Merchant.create!(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)

      @tire = @meg.items.create!(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      @bell = @meg.items.create!(name: "Bike Bell", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      @light = @meg.items.create!(name: "Bike Light", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      @bike_horn = @meg.items.create!(name: "Honk Honk", description: "Everyone will hear you comming", price: 20, image: "https://pbs.twimg.com/media/DkbR-8yVsAABrCg.png", inventory: 4)
      @bike_lock = @meg.items.create!(name: "Krytonite Lock", description: "Keep your lock safe while you're away.", price: 60, image: "https://i5.walmartimages.com/asr/875f4ecf-877b-41ad-8754-eb67e54e0fdd_1.c38843c2225b1b0ed22a6d5fe3fed788.jpeg", inventory: 4)
      @chain = @meg.items.create!(name: "Chain", description: "It'll never break!", price: 50, image: "https://www.rei.com/media/b61d1379-ec0e-4760-9247-57ef971af0ad?size=784x588", inventory: 5)
      @pull_toy = @brian.items.create!(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
      @dog_bone = @brian.items.create!(name: "Dog Bone", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", active?:false, inventory: 21)
      @dog_treat = @brian.items.create!(name: "Alaska's Organic Dog Treats", description: "Give your pup something really tasty and healthy!", price: 10, image: "https://alaskasbakery.com/wp-content/uploads/2016/08/all31.png", active?:false, inventory: 21)
      @leash = @brian.items.create!(name: "Dog Leash", description: "Give your pup something really tasty and healthy!", price: 10, image: "https://alaskasbakery.com/wp-content/uploads/2016/08/all31.png", active?:false, inventory: 21)

      @order_1 = @existing_user.orders.create!(name: 'Meg', address: '123 Stang St', city: 'Hershey', state: 'PA', zip: 80218)

      @order_1.item_orders.create!(item: @chain, price: @chain.price, quantity: 1)
      @order_1.item_orders.create!(item: @tire, price: @tire.price, quantity: 3)
      @order_1.item_orders.create!(item: @bell, price: @bell.price, quantity: 4)
      @order_1.item_orders.create!(item: @light, price: @light.price, quantity: 5)
      @order_1.item_orders.create!(item: @bike_horn, price: @bike_horn.price, quantity: 6)
      @order_1.item_orders.create!(item: @pull_toy, price: @pull_toy.price, quantity: 7)
      @order_1.item_orders.create!(item: @dog_bone, price: @dog_bone.price, quantity: 10)
      @order_1.item_orders.create!(item: @dog_treat, price: @dog_treat.price, quantity: 15)
    end

    it '#most_popular' do
      expect(Item.most_popular.first.name).to eq(@dog_treat.name)
      expect(Item.most_popular.last.name).to eq(@light.name)
    end

    it '#least_popular' do
      expect(Item.least_popular.first.name).to eq(@chain.name)
      expect(Item.least_popular.last.name).to eq(@bike_horn.name)
    end
  end
end
