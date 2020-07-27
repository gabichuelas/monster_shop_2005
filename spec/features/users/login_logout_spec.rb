RSpec.describe 'As a visitor' do
  describe 'When I visit the login path' do
    before :each do

      @dog_shop = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)
      @existing_user = User.create!(name: "Bob Vance",
                                    address: "123 ABC St.",
                                    city: "Denver",
                                    state: "Colorado",
                                    zip: "80202",
                                    email: "example@hotmail.com",
                                    password: "qwer",
                                    role: 0,
                                    merchant_id: @dog_shop.id)

      @existing_merchant = User.create!(name: "Jake from StateFarm",
                                    address: "Mechant St.",
                                    city: "Denver",
                                    state: "Colorado",
                                    zip: "80202",
                                    email: "example_merchant@hotmail.com",
                                    password: "qwer",
                                    role: 1,
                                    merchant_id: @dog_shop.id)

      @existing_admin = User.create!(name: "Chuck Norris",
                                    address: "Legend St.",
                                    city: "Denver",
                                    state: "Colorado",
                                    zip: "80202",
                                    email: "example_admin@hotmail.com",
                                    password: "qwer",
                                    role: 2,
                                    merchant_id: @dog_shop.id)


      @pull_toy = @dog_shop.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
      @dog_bone = @dog_shop.items.create(name: "Dog Bone", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", active?:false, inventory: 21)
    end

    it "can see a field to enter my email address and password, and as a regular user, I am redirected to my profile page" do

      visit "/login"
      fill_in :email, with: @existing_user.email
      fill_in :password, with: @existing_user.password
      click_on "Log In"

      expect(current_path).to eq("/profile")

      expect(page).to_not have_content('Login')
      expect(page).to_not have_content('Register')

      expect(page).to have_content('Profile')
      expect(page).to have_content('Logout')
      expect(page).to have_content("Welcome, #{@existing_user.name}! You are now logged in.")
    end

    it 'If I am a merchant user, I am redirected to the merchant dashboard and I see a flash message that I am now logged in' do

      visit '/login'
      fill_in :email, with: @existing_merchant.email
      fill_in :password, with: @existing_merchant.password
      click_button "Log In"

      expect(current_path).to eq('/merchant')

      expect(page).to_not have_content('Login')
      expect(page).to_not have_content('Register')

      expect(page).to have_content('Logout')
      expect(page).to have_content("Welcome, #{@existing_merchant.name}! You are now logged in.")
    end

    it 'If I am an admin user, I am redirected to the admin dashboard and I see a flash message that I am now logged in' do

      visit '/login'
      fill_in :email, with: @existing_admin.email
      fill_in :password, with: @existing_admin.password

      click_button "Log In"

      expect(current_path).to eq('/admin')

      expect(page).to_not have_content('Login')
      expect(page).to_not have_content('Register')

      expect(page).to have_content('Logout')
      expect(page).to have_content("Welcome, #{@existing_admin.name}! You are now logged in.")
    end

    it 'When I submit invalid information, I am redirected to the login page and see a flash message that my credentials were incorrect,
        I am NOT told whether it was my email or password that was incorrect' do
      visit '/login'

      fill_in :email, with: @existing_user.email
      fill_in :password, with: "wrongpassword"

      click_button "Log In"

      expect(current_path).to eq('/login')
      expect(page).to have_content("Sorry, your credentials are bad.")

      fill_in :email, with: "LandofPizza@pizza.com"
      fill_in :password, with: @existing_user.password

      click_button "Log In"

      expect(current_path).to eq('/login')
      expect(page).to have_content("Sorry, your credentials are bad.")
    end

    describe 'If a logged-in user, merchant, or admin visits the login path' do
      it 'If I am a regular user, I am redirected to my profile page and I see a flash message that tells me I am already logged in' do
        visit '/login'

        fill_in :email, with: @existing_user.email
        fill_in :password, with: @existing_user.password

        click_button "Log In"

        visit '/login'

        expect(current_path).to eq('/profile')
        expect(page).to have_content("You are already logged in!")
      end

      it 'If I am a merchant user, I am redirected to the merchant dashboard and I see a flash message telling me I am already logged in' do
        visit '/login'

        fill_in :email, with: @existing_merchant.email
        fill_in :password, with: @existing_merchant.password

        click_button "Log In"

        visit '/login'

        expect(current_path).to eq('/merchant')
        expect(page).to have_content("You are already logged in!")
      end

      it 'If I am an admin user, I am redirected to the admin dashboard and I see a flash message telling me I am already logged in' do
        visit '/login'

        fill_in :email, with: @existing_admin.email
        fill_in :password, with: @existing_admin.password

        click_button "Log In"

        visit '/login'

        expect(current_path).to eq('/admin')
        expect(page).to have_content("You are already logged in!")
      end

      describe 'When I visit the logout path' do
        it 'I am redirected to the welcome/home page of the site and see a flash message that indicates I am logged out. Items in cart are deleted' do

          visit '/login'

          fill_in :email, with: @existing_merchant.email
          fill_in :password, with: @existing_merchant.password

          click_button "Log In"

          visit "/items/#{@pull_toy.id}"
          click_on "Add To Cart"

          visit "/items/#{@dog_bone.id}"
          click_on "Add To Cart"

          expect(page).to have_content("Cart: 2")

          click_on 'Logout'

          expect(current_path).to eq("/")
          expect(page).to have_content("You have logged out.")
          expect(page).to have_content("Cart: 0")

          visit '/login'

          fill_in :email, with: @existing_user.email
          fill_in :password, with: @existing_user.password

          click_button "Log In"

          visit "/items/#{@pull_toy.id}"
          click_on "Add To Cart"

          visit "/items/#{@dog_bone.id}"
          click_on "Add To Cart"

          expect(page).to have_content("Cart: 2")

          click_on 'Logout'

          expect(current_path).to eq("/")
          expect(page).to have_content("You have logged out.")
          expect(page).to have_content("Cart: 0")
        end
      end
    end
  end
end
