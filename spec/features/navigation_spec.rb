
require 'rails_helper'

RSpec.describe 'Site Navigation' do
  describe 'As a Visitor' do
    it "A link to return to welcome/home page" do

      visit '/merchants'

      within 'nav' do
        click_link 'Home'
      end

      expect(current_path).to eq('/')
    end

    it "I see a nav bar with links to all pages" do
      visit '/merchants'

      within 'nav' do
        click_link 'All Items'
      end

      expect(current_path).to eq('/items')

      within 'nav' do
        click_link 'All Merchants'
      end

      expect(current_path).to eq('/merchants')
    end

    it "I can see a cart indicator on all pages" do
      visit '/merchants'

      within 'nav' do
        expect(page).to have_content("Cart: 0")
      end

      visit '/items'

      within 'nav' do
        expect(page).to have_content("Cart: 0")
      end
    end

    it "A link to log in (\"/login\")" do

      visit '/'

      within 'nav' do
        click_link 'Login'
      end

      expect(current_path).to eq('/login')
    end

    it "a link to the user registration page (\"/register\")" do

      visit '/'

      within 'nav' do
        click_link 'Register'
      end

      expect(current_path).to eq('/register')
    end
  end
end
