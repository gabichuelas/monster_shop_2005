RSpec.describe 'As a merchant employee' do
  before :each do
    @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
    @brian = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)

    @user1 = User.create!(name: "Bob Vance", address: "123 ABC St.", city: "Denver", state: "Colorado", zip: "80202", email: "example@hotmail.com", password: "qwer", role: 0)
    @user2 = User.create!(name: "Jake", address: "1234 DEF St.", city: "Denver", state: "Colorado", zip: "80202", email: "example2@hotmail.com", password: "qwer", role: 0)
    @user3 = User.create!(name: "Jackie", address: "567 Ghi St.", city: "Denver", state: "Colorado", zip: "80202", email: "example3@hotmail.com", password: "qwer", role: 0)

    @chain = @meg.items.create(name: "Chain", description: "It'll never break!", price: 50, image: "https://www.rei.com/media/b61d1379-ec0e-4760-9247-57ef971af0ad?size=784x588", inventory: 5)
    @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12, active?: false)
    @pull_toy = @brian.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
    @dog_bone = @brian.items.create(name: "Dog Bone", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", inventory: 21)

    @order_1 = @user1.orders.create!(name: 'Bob Vance', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033, status: "shipped")
    @order_2 = @user2.orders.create!(name: 'Jake', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033, status: "pending")
    @order_3 = @user2.orders.create!(name: 'Bob Vance', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033, status: "cancelled")


    @order_1.item_orders.create!(item: @tire, price: @tire.price, quantity: 2)
    @order_1.item_orders.create!(item: @pull_toy, price: @pull_toy.price, quantity: 3)
    @order_2.item_orders.create!(item: @tire, price: @tire.price, quantity: 1)
    @order_2.item_orders.create!(item: @chain, price: @chain.price, quantity: 2)
    @order_2.item_orders.create!(item: @dog_bone, price: @dog_bone.price, quantity: 2)
    #@order_3.item_orders.create!(item: @tire, price: @tire.price, quantity: 2, fulfilled: true) <---- Will need to add fulfilled to itemorders in migrations if we want to use a boolean for this

    @merchant_employee = User.create!(name: "Jose", address: "789 Jkl St.", city: "Denver", state: "Colorado", zip: "80202", email: "example4@hotmail.com", password: "qwer", role: 1, merchant_id: @meg.id)

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant_employee)
  end

  describe 'When I visit an order show page from my dashboard' do
    before(:each) do
      visit '/merchant'

      click_on "#{@order_1.id}" #<------ need to add link to view, only added customer info
    end

    it "I see the customer's name and address" do
      expect(page).to have_content("Customer Name: #{@order_1.name}")
      expect(page).to have_content("Address: #{@order_1.address} #{@order_1.city}, #{@order_1.state} #{@order_1.zip}")
    end

    it 'I only see the items in the order that are being purchased from my merchant' do
      expect(page).to have_content(@chain.name) #chain is the merchant meg's item
    end

    it 'I do not see any items in the order being purchased from other merchants' do
      expect(page).to_not have_content(@dog_bone.name) #dog_bone is the merchant brian's item
    end

    it 'For each item, I see the name of the item which links to the item\'s show page, an image, price, and quantity user is purchasing for this item' do
      expect(page).to have_link(@chain.name, href: "/merchant/items/#{@chain.id}")
      expect(page).to have_css("img[src*='#{@chain.image}']")
      expect(page).to have_content("Price: $#{@chain.price}.00") # Can we use number to currency instead of hard coding here?
      expect(page).to have_content("Quantity: #{@order_2.quantity}")
    end

    describe 'For each item of mine in the order,
              if the user\'s desired quantity is equal to
              or less than my current inventory quantity for that item,
              And I have not already \"fulfilled\" that item' do

      it 'Then I see a button or link to "fulfill" that item' do
        within "#item-#{@chain.id}" do
          expect(page).to have_button('Fulfill Order') #<------ need to add button to view
        end
      end

      describe 'When I click on that link or button' do
        it 'I am returned to the order show page' do
          click_on 'Fulfill Order'
          expect(current_path).to eq("/merchant/orders/#{@order_2.id}")
        end

        it 'I see the item is now fulfilled' do
          click_on 'Fulfill Order'
          within "#item-#{@chain.id}" do
            expect(page).to have_content("Order Fulfilled") #<----- In view, you can have if item is not fulfilled, have this button to fulfill order, else <p> Order Fulfilled </p>
          end
        end

        it 'I also see a flash message indicating that I have fulfilled that item' do
          click_on 'Fulfill Order'
          expect(page).to have_content("This order has been fulfilled") #<----- Add flash message
        end

        it "the item's inventory quantity is permanently reduced by the user's desired quantity" do
          click_on 'Fulfill Order'
          visit "/items/#{@chain.id}"

          expect(page).to have_content("Inventory: 3") #<------ I believe this should be 3, but my maths may be wrong.
        end

        it "If I have already fulfilled this item, I see text indicating such" do
          click_on 'Fulfill Order'
          visit "/merchant/orders/#{@order_3.id}" #<---- will need to uncomment order_3 and add a migration?

          within "#item-#{@tire.id}" do
            expect(page).to have_content("Order Fulfilled")
            expect(page).to_not have_button("Fulfill Order")
          end
        end
      end
    end
  end
end
