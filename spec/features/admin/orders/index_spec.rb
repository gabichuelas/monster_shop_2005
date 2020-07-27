require 'rails_helper'

RSpec.describe "Admin dashboard" do
  before(:each) do
    @existing_admin = User.create!(name: "Chuck Norris",
                                  address: "Legend St.",
                                  city: "Denver",
                                  state: "Colorado",
                                  zip: "80202",
                                  email: "example_admin@hotmail.com",
                                  password: "qwer",
                                  role: 2)

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@existing_admin)

    @user1 = User.create!(name: "Bob Vance", address: "123 ABC St.", city: "Denver", state: "Colorado", zip: "80202", email: "example@hotmail.com", password: "qwer", role: 0)
    @user2 = User.create!(name: "Jake", address: "1234 DEF St.", city: "Denver", state: "Colorado", zip: "80202", email: "example2@hotmail.com", password: "qwer", role: 0)
    @user3 = User.create!(name: "Jackie", address: "567 Ghi St.", city: "Denver", state: "Colorado", zip: "80202", email: "example3@hotmail.com", password: "qwer", role: 0)
    @user4 = User.create!(name: "Jose", address: "789 Jkl St.", city: "Denver", state: "Colorado", zip: "80202", email: "example4@hotmail.com", password: "qwer", role: 0)

    @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
    @brian = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)

    @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
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
    @order_3.item_orders.create!(item: @dog_bone, price: @dog_bone.price, quantity: 2)
    @order_4.item_orders.create!(item: @tire, price: @tire.price, quantity: 2)
    @order_5.item_orders.create!(item: @pull_toy, price: @pull_toy.price, quantity: 1)
  end

  it "displays all orders in the system sorted by status" do

    visit '/admin'

    within '.packaged' do
      expect(page).to have_link("#{@order_3.user.name}")
      expect(page).to have_content("#{@order_3.id}")
      expect(page).to have_content("#{@order_3.created_at}")
    end

    within '.pending' do
      expect(page).to have_link("#{@order_2.user.name}")
      expect(page).to have_content("#{@order_2.id}")
      expect(page).to have_content("#{@order_2.created_at}")
    end

    within '.shipped' do
      expect(page).to have_link("#{@order_1.user.name}")
      expect(page).to have_content("#{@order_1.id}")
      expect(page).to have_content("#{@order_1.created_at}")

      expect(page).to have_link("#{@order_4.user.name}")
      expect(page).to have_content("#{@order_4.id}")
      expect(page).to have_content("#{@order_4.created_at}")
    end

    within '.cancelled' do
      expect(page).to have_link("#{@order_5.user.name}")
      expect(page).to have_content("#{@order_5.id}")
      expect(page).to have_content("#{@order_5.created_at}")
    end
  end

  it 'each user order name is a link to the admin view of their user profile' do

    visit '/admin'

    within '.packaged' do
      expect(page).to have_link("#{@order_3.user.name}")
      click_on "#{@order_3.user.name}"
    end
    expect(current_path).to eq("/admin/users/#{@user3.id}")
  end

  it 'I see all packaged orders, and next to each order a button to "ship" the order' do
    visit '/admin'

    within '.packaged' do
      expect(page).to have_content("#{@order_3.id}")
      expect(page).to have_button('Ship', count: 1)
    end
  end

  describe 'When I click the ship button' do
    it 'the status of that order changes to "shipped"' do

      visit '/admin'

      within '.packaged' do
        click_on 'Ship'
      end

      expect(current_path).to eq('/admin')

      within '.packaged' do
        expect(page).not_to have_content("#{@order_3.id}")
      end

      expect(current_path).to eq('/admin')

      within '.shipped' do
        expect(page).to have_content("#{@order_3.id}")
      end
    end

    it 'after an order is shipped, the order can no longer be cancelled' do
      visit '/admin'

      within '.packaged' do
        click_on 'Ship'
      end

      @order_3.reload
      expect(@order_3.status).to eq("shipped")

      visit "profile/orders/#{@order_3.id}"
      expect(page).to have_content("Status: shipped")
      expect(page).to_not have_link('Cancel Order')
    end
  end
end
