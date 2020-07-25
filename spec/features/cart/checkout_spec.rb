require 'rails_helper'

RSpec.describe 'Cart show' do
  describe 'When I have added items to my cart' do
    before(:each) do
      @mike = Merchant.create(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)

      @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      @paper = @mike.items.create(name: "Lined Paper", description: "Great for writing on!", price: 20, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png", inventory: 3)
      @pencil = @mike.items.create(name: "Yellow Pencil", description: "You can write on paper with it!", price: 2, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 100)
      visit "/items/#{@paper.id}"
      click_on "Add To Cart"
      visit "/items/#{@tire.id}"
      click_on "Add To Cart"
      visit "/items/#{@pencil.id}"
      click_on "Add To Cart"
      @items_in_cart = [@paper,@tire,@pencil]
    end

    it 'Theres a link to checkout' do
      visit "/cart"

      expect(page).to have_link("Checkout")

      click_on "Checkout"

      expect(current_path).to eq("/orders/new")
    end

    describe 'When I have items in my cart and I visit my cart' do
      it 'I see text informing me that I must register or log in to finish checking out' do

        visit '/cart'

        expect(page).to have_content('You must register or log in to checkout!')
      end

      it 'The word "register" is a link to the registration page' do

        visit '/cart'

        within '#nav-options' do
          expect(page).to have_link('register', href: '/register')
        end
      end

      it 'The words "log in" are a link to the login page' do
        visit '/cart'

        within '#nav-options' do
          expect(page).to have_link('log in', href: '/login')
        end
      end
    end
  end

  describe "As a registered user" do
    before(:each) do
      @user = User.create!(name: "Bob Vance",
                                    address: "123 ABC St.",
                                    city: "Denver",
                                    state: "CO",
                                    zip: "80202",
                                    email: "example@hotmail.com",
                                    password: "qwer",
                                    role: 0)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
    end

    describe 'When I add items to my cart and I visit my cart' do
      before(:each) do
        @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
        @paper = @meg.items.create(name: "Lined Paper", description: "Great for writing on!", price: 20, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png", inventory: 3)
        @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
        visit "/items/#{@paper.id}"
        click_on 'Add To Cart'
        visit "/items/#{@tire.id}"
        click_on 'Add To Cart'
        visit '/cart'
      end

      it 'I see a button or link indicating that I can check out' do

        within "#nav-options" do
          expect(page).to have_link('Checkout')
        end
      end

      describe 'When I click the button or link to check out' do
        it 'I am taken to a new order creation form' do
          click_on('Checkout')

          expect(current_path).to eq('/orders/new')
        end

        describe 'When I click the button or link to create the order' do
          it 'an order is created with a status of pending' do
            click_on('Checkout')

            fill_in :name, with: @user.name
            fill_in :address, with: @user.address
            fill_in :city, with: @user.city
            fill_in :state, with: @user.state
            fill_in :zip, with: @user.zip
            click_on('Create Order')

            new_order = Order.last

            expect(current_path).to eq("/profile/orders")

            within "#order-#{new_order.id}" do
              expect(page).to have_content('Status: pending')
            end
          end

          it 'I see a flash message that my order was created, my cart is now empty, and my new order is listed on my profile orders page' do
            click_on('Checkout')

            fill_in :name, with: @user.name
            fill_in :address, with: @user.address
            fill_in :city, with: @user.city
            fill_in :state, with: @user.state
            fill_in :zip, with: @user.zip
            click_on('Create Order')

            new_order = Order.last

            expect(page).to have_content("Your order has been created.")
            expect(page).to have_content("#{new_order.id}")
            expect(page).to_not have_link("Checkout")
          end
        end
      end
    end
  end

  describe 'When I havent added items to my cart' do
    it 'There is not a link to checkout' do
      visit "/cart"

      expect(page).to_not have_link("Checkout")
    end
  end
end
