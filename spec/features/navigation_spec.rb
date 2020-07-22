
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

    it "When I try to access any path that begins with the following, then I see a 404 error:
      /merchant, /admin, /profile" do

      visit '/merchant'
      expect(page).to have_content('The page you were looking for doesn\'t exist.')

      visit '/admin'
      expect(page).to have_content('The page you were looking for doesn\'t exist.')

      visit '/profile'
      expect(page).to have_content('The page you were looking for doesn\'t exist.')
    end
  end

  describe 'As a User' do
    describe 'I see the same links as a visitor' do

      before :each do
        @existing_user = User.create!(name: "Bob Vance",
                                      address: "123 ABC St.",
                                      city: "Denver",
                                      state: "Colorado",
                                      zip: "80202",
                                      email: "example@hotmail.com",
                                      password: "qwer",
                                      role: 0)

        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@existing_user)
      end

      it 'Plus the following links: /profile, /logout' do

        visit '/'

        within 'nav' do
          expect(page).to have_content('Home')
          expect(page).to have_content('All Items')
          expect(page).to have_content('All Merchants')
          expect(page).to have_content('Cart: 0')

          expect(page).to_not have_content('Login')
          expect(page).to_not have_content('Register')

          expect(page).to have_content('Profile')
          expect(page).to have_content('Logout')

          expect(page).to have_content('Logged in as Bob Vance')
        end
      end

      it 'When I try to access any path that begins with the following, then I see a 404 error: /merchant, /admin' do

        visit '/merchant'
        expect(page).to have_content('The page you were looking for doesn\'t exist.')

        visit '/admin'
        expect(page).to have_content('The page you were looking for doesn\'t exist.')
      end
    end
  end

  describe 'As a merchant employee' do
    describe 'I see the same links as a regular user' do

      before :each do
        @merchant = User.create!(name: "Merchant Dude",
                                      address: "123 ABC St.",
                                      city: "Denver",
                                      state: "Colorado",
                                      zip: "80202",
                                      email: "merchant@hotmail.com",
                                      password: "qwer",
                                      role: 1)

        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant)
      end

      it 'Plus the following link to my merchant dashboard \"/merchant\"' do

        visit '/'

        within 'nav' do
          expect(page).to have_content('Home')
          expect(page).to have_content('All Items')
          expect(page).to have_content('All Merchants')
          expect(page).to have_content('Cart: 0')

          expect(page).to_not have_content('Login')
          expect(page).to_not have_content('Register')

          expect(page).to have_content('Profile')
          expect(page).to have_content('Logout')
          expect(page).to have_content('Dashboard')
        end
      end

      it 'When I try to access any path that begins with the following, then I see a 404 error: /admin' do

        visit '/admin'
        expect(page).to have_content('The page you were looking for doesn\'t exist.')
      end
    end
  end

  describe 'As an Admin' do
    describe 'I see the same links as a regular user' do

      before :each do
        @admin = User.create!(name: "Admin Boss",
                                      address: "123 ABC St.",
                                      city: "Denver",
                                      state: "Colorado",
                                      zip: "80202",
                                      email: "admin@hotmail.com",
                                      password: "qwer",
                                      role: 2)

        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@admin)
      end

      it 'plus a link to my admin dashboard, a link to see all users, and MINUS a link to the cart' do

        visit '/'

        within 'nav' do
          expect(page).to have_content('Home')
          expect(page).to have_content('All Items')
          expect(page).to have_content('All Merchants')

          expect(page).to_not have_content('Cart: 0')
          expect(page).to_not have_content('Login')
          expect(page).to_not have_content('Register')

          expect(page).to have_content('Profile')
          expect(page).to have_content('Logout')
          expect(page).to have_content('Dashboard')
          expect(page).to have_content('All Users')
        end
      end

      it 'When I try to access any path that begins with the following, then I see a 404 error: /merchant, /cart' do

        visit '/merchant'
        expect(page).to have_content('The page you were looking for doesn\'t exist.')

        visit '/cart'
        expect(page).to have_content('The page you were looking for doesn\'t exist.')
      end
    end
  end
end
