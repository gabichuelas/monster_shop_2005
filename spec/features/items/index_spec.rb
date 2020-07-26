require 'rails_helper'

RSpec.describe "Items Index Page" do
  describe "When I visit the items index page" do
    before(:each) do
      @existing_user = User.create!(name: "Bob Vance",
                                    address: "123 ABC St.",
                                    city: "Denver",
                                    state: "Colorado",
                                    zip: "80202",
                                    email: "example@hotmail.com",
                                    password: "qwer",
                                    role: 0)


      @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @brian = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)

      @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)

      @bell = @meg.items.create(name: "Bike Bell", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)

      @light = @meg.items.create(name: "Bike Light", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)

      @bike_horn = @meg.items.create(name: "Honk Honk", description: "Everyone will hear you comming", price: 20, image: "https://pbs.twimg.com/media/DkbR-8yVsAABrCg.png", inventory: 4)

      @bike_lock = @meg.items.create(name: "Krytonite Lock", description: "Keep your lock safe while you're away.", price: 60, image: "https://i5.walmartimages.com/asr/875f4ecf-877b-41ad-8754-eb67e54e0fdd_1.c38843c2225b1b0ed22a6d5fe3fed788.jpeg", inventory: 4)

      @chain = @meg.items.create(name: "Chain", description: "It'll never break!", price: 50, image: "https://www.rei.com/media/b61d1379-ec0e-4760-9247-57ef971af0ad?size=784x588", inventory: 5)

      @pull_toy = @brian.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)

      @dog_bone = @brian.items.create(name: "Dog Bone", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", active?:false, inventory: 21)

      @dog_treat = @brian.items.create(name: "Alaska's Organic Dog Treats", description: "Give your pup something really tasty and healthy!", price: 10, image: "https://alaskasbakery.com/wp-content/uploads/2016/08/all31.png", active?:false, inventory: 21)

      @leash = @brian.items.create(name: "Dog Leash", description: "Give your pup something really tasty and healthy!", price: 10, image: "https://alaskasbakery.com/wp-content/uploads/2016/08/all31.png", active?:false, inventory: 21)



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

    it "all items or merchant names are links" do
      visit '/items'

      expect(page).to have_link(@tire.name)
      expect(page).to have_link(@tire.merchant.name)
      expect(page).to have_link(@pull_toy.name)
      expect(page).to have_link(@pull_toy.merchant.name)
    end

    it "I can see a list of all of the items "do

      visit '/items'

      within "#item-#{@tire.id}" do
        expect(page).to have_link(@tire.name)
        expect(page).to have_content(@tire.description)
        expect(page).to have_content("Price: $#{@tire.price}")
        expect(page).to have_content("Active")
        expect(page).to have_content("Inventory: #{@tire.inventory}")
        expect(page).to have_link(@meg.name)
        expect(page).to have_css("img[src*='#{@tire.image}']")
      end

      within "#item-#{@pull_toy.id}" do
        expect(page).to have_link(@pull_toy.name)
        expect(page).to have_content(@pull_toy.description)
        expect(page).to have_content("Price: $#{@pull_toy.price}")
        expect(page).to have_content("Active")
        expect(page).to have_content("Inventory: #{@pull_toy.inventory}")
        expect(page).to have_link(@brian.name)
        expect(page).to have_css("img[src*='#{@pull_toy.image}']")
      end

    end

    it "as any kind of user, when I visit the items index page, I see all items, except the disabled items." do

      visit "/login"
      fill_in :email, with: @existing_user.email
      fill_in :password, with: @existing_user.password
      click_on "Log In"

      visit "/items"

      expect(page).to have_link(@tire.name)
      expect(page).to have_link(@tire.merchant.name)
      expect(page).to have_link(@pull_toy.name)
      expect(page).to have_link(@pull_toy.merchant.name)

      expect(page).to_not have_link(@dog_bone.name)

    end

    it "can see top 5 most popular items and bottom 5 least popular items" do

      visit '/items'

      within ".most_popular" do
        expect(page).to have_content("#{@dog_treat.name} quantity: 15")
        expect(page).to have_content("#{@dog_bone.name} quantity: 10")
        expect(page).to have_content("#{@pull_toy.name} quantity: 7")
        expect(page).to have_content("#{@bike_horn.name} quantity: 6")
        expect(page).to have_content("#{@light.name} quantity: 5")
        expect(page).to_not have_content("#{@chain.name} quantity: 1")

      end

      within ".least_popular" do
        expect(page).to have_content("#{@chain.name} quantity: 1")
        expect(page).to have_content("#{@tire.name} quantity: 3")
        expect(page).to have_content("#{@bell.name} quantity: 4")
        expect(page).to have_content("#{@light.name} quantity: 5")
        expect(page).to have_content("#{@bike_horn.name} quantity: 6")
        expect(page).to_not have_content("#{@dog_treat.name} quantity: 15")
      end

    end
  end
end
