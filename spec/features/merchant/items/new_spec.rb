RSpec.describe 'As a merchant employee' do

  before :each do
    @bike_shop = Merchant.create!(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)

    @merch_emp = User.create!(name: "Merchant Employee",
                        address: "123 ABC St.",
                        city: "Denver",
                        state: "CO",
                        zip: "80202",
                        email: "merch_emp@hotmail.com",
                        password: "qwer",
                        role: 1,
                        merchant_id: @bike_shop.id )

    @tire = @bike_shop.items.create!(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)

    @bike_horn = @bike_shop.items.create!(name: "Honk Honk", description: "Everyone will hear you comming", price: 20, image: "https://pbs.twimg.com/media/DkbR-8yVsAABrCg.png", inventory: 4)

    @bike_lock = @bike_shop.items.create!(name: "Krytonite Lock", description: "Keep your lock safe while you're away.", price: 60, image: "https://i5.walmartimages.com/asr/875f4ecf-877b-41ad-8754-eb67e54e0fdd_1.c38843c2225b1b0ed22a6d5fe3fed788.jpeg", inventory: 4)

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merch_emp)
  end

  describe 'When I visit my items page, I see a link to add a new item' do
    describe 'When I click on the link to add a new item, I see a form where I can add new information about an item, including: name, description, optional thumbnail image URL, a price (> $0), and current inventory (must be >= 0)' do
      it 'When I submit valid information and submit the form, I am taken back to my items page; I see a flash message indicating my new item is saved; I see the new item on the page, and it is enabled and available for sale' do
        #
        visit "/merchant/items"
        click_on "Add New Item"
        expect(current_path).to eq("/merchant/items/new")

        fill_in 'Name', with: 'Shift Cable, Road'
        fill_in 'Description', with: 'Round head for STI road levers'
        fill_in 'Image', with: 'https://cdn.bike24.net/i/mb/04/f1/58/146905-00-d-258058.jpg'
        fill_in 'Price', with: 6.50
        fill_in 'Inventory', with: 100

        click_on 'Create Item'
        new_item = Item.last

        expect(current_path).to eq("/merchant/items")

        within "#item-#{new_item.id}" do
          expect(page).to have_link(new_item.name)
          expect(page).to have_content(new_item.description)
          expect(page).to have_content("Price: $#{new_item.price}")
          expect(page).to have_content("Active")
          expect(page).to have_content("Inventory: #{new_item.inventory}")
          expect(page).to have_css("img[src*='#{new_item.image}']")
        end
      end

      it 'If I left the image field blank, I see a placeholder image for the thumbnail' do
        #
        visit "/merchant/items"

        click_on "Add New Item"
        expect(current_path).to eq("/merchant/items/new")

        fill_in 'Name', with: 'Shift Cable, Road'
        fill_in 'Description', with: 'Round head for STI road levers'
        fill_in 'Price', with: 6.50
        fill_in 'Inventory', with: 100

        click_on 'Create Item'
        new_item = Item.last

        expect(current_path).to eq("/merchant/items")
        save_and_open_page
        within "#item-#{new_item.id}" do
          expect(page).to have_css("img[src*='https://miro.medium.com/max/1200/1*mk1-6aYaf_Bes1E3Imhc0A.jpeg']")
        end
      end
    end
  end
end
