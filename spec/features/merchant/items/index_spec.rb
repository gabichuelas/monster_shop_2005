RSpec.describe 'As a merchant employee' do
  before :each do
    @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)

    @chain = @meg.items.create(name: "Chain", description: "It'll never break!", price: 50, image: "https://www.rei.com/media/b61d1379-ec0e-4760-9247-57ef971af0ad?size=784x588", inventory: 5)
    @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12, active?: false)

    @merchant_employee = User.create!(name: "Jose", address: "789 Jkl St.", city: "Denver", state: "Colorado", zip: "80202", email: "example4@hotmail.com", password: "qwer", role: 1, merchant_id: @meg.id)

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant_employee)
  end

  describe 'When I visit my merchant dashboard' do
    it "I can deactivate any active items" do
      visit "/merchant/items"

      within "#item-#{@chain.id}" do
        expect(page).to have_content("Active")
        click_button 'Deactivate'

        expect(current_path).to eq("/merchant/items")
        expect(page).to have_content("Inactive")
      end
      expect(page).to have_content("This item is now inactive")
    end

    it "I can activate any inactive items" do
      visit "/merchant/items"

      within "#item-#{@tire.id}" do
        expect(page).to have_content("Inactive")
        click_button 'Activate'

        expect(current_path).to eq("/merchant/items")
        expect(page).to have_content("Active")
      end
      expect(page).to have_content("This item is now active")
    end
  end
end
