RSpec.describe 'As a visitor' do
  describe 'When I visit the login path' do
    before :each do

      @existing_user = User.create!(name: "Bob Vance",
                                    address: "123 ABC St.",
                                    city: "Denver",
                                    state: "Colorado",
                                    zip: "80202",
                                    email: "example@hotmail.com",
                                    password: "qwer",
                                    role: 0)

      @existing_merchant = User.create!(name: "Jake from StateFarm",
                                    address: "Mechant St.",
                                    city: "Denver",
                                    state: "Colorado",
                                    zip: "80202",
                                    email: "example_merchant@hotmail.com",
                                    password: "qwer",
                                    role: 1)

      @existing_admin = User.create!(name: "Chuck Norris",
                                    address: "Legend St.",
                                    city: "Denver",
                                    state: "Colorado",
                                    zip: "80202",
                                    email: "example_admin@hotmail.com",
                                    password: "qwer",
                                    role: 2)
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

    xit 'If I am a merchant user, I am redirected to the merchant dashboard and I see a flash message that I am now logged in' do

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

    xit 'If I am an admin user, I am redirected to the admin dashboard and I see a flash message that I am now logged in' do

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
  end

  describe 'When I submit invalid information' do
    xit 'I am redirected to the login page and see a flash message that my credentials were incorrect,
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
  end

  describe 'If a logged-in user, merchant, or admin visits the login path' do
    xit 'If I am a regular user, I am redirected to my profile page and I see a flash message that tells me I am already logged in' do
      visit '/login'

      fill_in :email, with: @existing_user.email
      fill_in :password, with: @existing_user.password

      click_button "Log In"

      visit '/login'

      expect(current_path).to eq('/profile')
      expect(page).to have_content("#{@existing_user.name}, you are already logged in!") #<---- will need to add this flash message
    end

    xit 'If I am a merchant user, I am redirected to the merchant dashboard and I see a flash message telling me I am already logged in' do
      visit '/login'

      fill_in :email, with: @existing_merchant.email
      fill_in :password, with: @existing_merchant.password

      click_button "Log In"

      visit '/login'

      expect(current_path).to eq('/merchant') #<---- Not sure if this is the correct path
      expect(page).to have_content("#{@existing_merchant.name}, you are already logged in!")
    end

    xit 'If I am an admin user, I am redirected to the admin dashboard and I see a flash message telling me I am already logged in' do
      visit '/login'

      fill_in :email, with: @existing_admin.email
      fill_in :password, with: @existing_admin.password

      click_button "Log In"

      visit '/login'

      expect(current_path).to eq('/admin') #<---- Not sure if this is the correct path
      expect(page).to have_content("#{@existing_admin.name}, you are already logged in!")
    end
  end
end
