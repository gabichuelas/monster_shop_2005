RSpec.describe 'As a merchant employee' do
  before :each do
    @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)

    @merchant_employee = User.create!(name: "Jose", address: "789 Jkl St.", city: "Denver", state: "Colorado", zip: "80202", email: "example4@hotmail.com", password: "qwer", role: 1, merchant_id: @meg.id)

    @user1 = User.create!(name: "Bob Vance",
                                  address: "123 ABC St.",
                                  city: "Denver",
                                  state: "CO",
                                  zip: "80202",
                                  email: "example@hotmail.com",
                                  password: "qwer",
                                  role: 0)


    @tire = @meg.items.create!(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
    @pull_toy = @meg.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
    @dog_bone = @meg.items.create(name: "Dog Bone", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", inventory: 21)

    @order_1 = @user1.orders.create!(name: 'Bob Vance', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033, status: "shipped")

    @order_1.item_orders.create!(item: @tire, price: @tire.price, quantity: 2)


    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant_employee)
  end

  describe 'When I visit my merchant dashboard' do
    it 'I see a link to view my own items; When I click that link; My URI route should be "/merchant/items"' do

      visit "/merchant"
      click_on "View My Items"
      expect(current_path).to eq("/merchant/items")
    end
  end

  describe 'When I visit my items index page' do
    it 'I see a link to delete the item next to each item that has never been ordered' do
      visit "/merchant/items"

      within "#item-#{@tire.id}" do
        expect(page).to_not have_button('Delete')
      end

      within "#item-#{@pull_toy.id}" do
        expect(page).to have_button('Delete')
      end

      within "#item-#{@dog_bone.id}" do
        expect(page).to have_button('Delete')
      end

      within "#item-#{@dog_bone.id}" do
        click_on "Delete"
      end

      expect(current_path).to eq('/merchant/items')

      expect(page).to have_content("#{@dog_bone.name} has been deleted")
      expect(page).to_not have_content(@dog_bone.name)

    end
  end

  describe "When I visit my items page" do
    it "can edit an items info" do
      visit "/merchant/items"

      within "#item-#{@tire.id}" do
        expect(page).to_not have_button('Edit')
        click_on "Edit"
      end

      expect(current_path).to eq("/merchant/items/#{@tire.id}/edit")

      expect(page).to have_content(@tire.name)
      expect(page).to have_content(@tire.description)
      expect(page).to have_content(@tire.price)
      expect(page).to have_content(@tire.image)
      expect(page).to have_content(@tire.inventory)

      fill_in "Description", with: "Indestructable"
      click_on "Submit"

      expect(current_path).to eq("/merchant/items")
      expect(page).to have_content("#{@tire.name} has been updated")

      within "#item-#{@tire.id}" do
        expect(page).to have_content("Indestructable")
      end

    end
  end
end


# User Story 44, Merchant deletes an item
#
# As a merchant employee
# When I visit my items page
# I see a button or link to delete the item next to each item that has never been ordered
# When I click on the "delete" button or link for an item
# I am returned to my items page
# I see a flash message indicating this item is now deleted
# I no longer see this item on the page

# User Story 47, Merchant edits an item
#
# As a merchant employee
# When I visit my items page
# And I click the edit button or link next to any item
# Then I am taken to a form similar to the 'new item' form
# The form is pre-populated with all of this item's information
# I can change any information, but all of the rules for adding a new item still apply:
# - name and description cannot be blank
# - price cannot be less than $0.00
# - inventory must be 0 or greater
#
# When I submit the form
# I am taken back to my items page
# I see a flash message indicating my item is updated
# I see the item's new information on the page, and it maintains its previous enabled/disabled state
# If I left the image field blank, I see a placeholder image for the thumbnail
