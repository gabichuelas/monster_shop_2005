RSpec.describe 'As an admin' do

  before :each do
    @bike_shop = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)

    @admin = User.create!(name: "Admin", address: "789 Jkl St.", city: "Denver", state: "FL", zip: "80202", email: "admin@hotmail.com", password: "qwer", role: 2)

    @tire = @bike_shop.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)

    @bike_horn = @bike_shop.items.create(name: "Honk Honk", description: "Everyone will hear you comming", price: 20, image: "https://pbs.twimg.com/media/DkbR-8yVsAABrCg.png", inventory: 4)

    @bike_lock = @bike_shop.items.create(name: "Krytonite Lock", description: "Keep your lock safe while you're away.", price: 60, image: "https://i5.walmartimages.com/asr/875f4ecf-877b-41ad-8754-eb67e54e0fdd_1.c38843c2225b1b0ed22a6d5fe3fed788.jpeg", inventory: 4)

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@admin)
  end

  describe 'When I visit the merchant index page' do
    it 'And I click on the "disable" button for an enabled merchant; Then all of that merchant\'s items should be deactivated' do
      
      visit "/admin/merchants"

      click_on "Disable"

      expect(@tire.active?).to eq(false)
      expect(@bike_horn.active?).to eq(false)
      expect(@bike_lock.active?).to eq(false)
    end
  end
end
