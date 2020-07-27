require 'rails_helper'

RSpec.describe 'merchant show page', type: :feature do
  describe 'As a user' do
    before :each do
      @bike_shop = Merchant.create(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Richmond', state: 'VA', zip: 23137)
    end

    it 'I can see a merchants name, address, city, state, zip' do
      visit "/merchants/#{@bike_shop.id}"

      expect(page).to have_content("Brian's Bike Shop")
      expect(page).to have_content("123 Bike Rd.\nRichmond, VA 23137")
    end

    it 'I can see a link to visit the merchant items' do
      visit "/merchants/#{@bike_shop.id}"

      expect(page).to have_link("All #{@bike_shop.name} Items")

      click_on "All #{@bike_shop.name} Items"

      expect(current_path).to eq("/merchants/#{@bike_shop.id}/items")
    end
  end

  describe 'As an admin' do
    before :each do

      @admin = User.create!(name: "Jose", address: "789 Jkl St.", city: "Denver", state: "Colorado", zip: "80202", email: "example4@hotmail.com", password: "qwer", role: 2)

      @bike_shop = Merchant.create(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Richmond', state: 'VA', zip: 23137)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@admin)
    end

    describe 'When I visit the merchant index page ("/merchants")' do

      it 'And I click on a merchant\'s name; Then my URI route should be ("/admin/merchants/6"); Then I see everything that merchant would see' do

        visit "/merchants"
        click_on "Brian's Bike Shop"
        expect(current_path).to eq("/admin/merchants/#{@bike_shop.id}")

        expect(page).to have_content("Brian's Bike Shop")
        expect(page).to have_content("123 Bike Rd.\nRichmond, VA 23137")
        expect(page).to have_link("All #{@bike_shop.name} Items")
      end
    end
  end
end
