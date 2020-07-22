RSpec.describe 'As a visitor' do
  describe 'When I click on the register link in the nav bar' do
    describe 'Then I am on the user registration page (\'register\')' do
      describe 'And I see a form where I input the following data: name, street address, city, state, zip code, email address, password, password confirmation' do

        before :each do

          @existing_user = User.create!(name: "Bob Vance",
                                        address: "123 ABC St.",
                                        city: "Denver",
                                        state: "Colorado",
                                        zip: "80202",
                                        email: "example@hotmail.com",
                                        password: "qwer",
                                        role: 0)

          # define form variables here for cleaner tests
          @name = "Dan Harmon"
          @address = "CBA St."
          @city = "Denver"
          @state = "Colorado"
          @zip = "80202"
          @email = "example_2@hotmail.com"
          @password = "friends"
        end

        it 'When I fill in this form completely, and with a unique email address, my details are saved in the db, then I am logged in as a registered user, I am taken to my profile page (\'/profile\'), I see a flash message indicating I am now registered and logged in' do

          visit "/"
          click_on 'Register'
          expect(current_path).to eq("/register")

          fill_in :name, with: @name
          fill_in :address, with: @address
          fill_in :city, with: @city
          fill_in :state, with: @state
          fill_in :zip, with: @zip
          fill_in :email, with: @email
          fill_in :password, with: @password
          fill_in :password_confirmation, with: @password

          click_on 'Register Now'
          new_user = User.last

          allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@new_user)

          expect(current_path).to eq("/profile")

          expect(page).to have_content("You are now registered and logged in")
        end

        it 'And I do not fill in this form completely; I am returned to the registration page; And I see a flash message indicating that I am missing required fields' do

          visit "/register"

          fill_in :name, with: @name
          fill_in :address, with: @address
          fill_in :city, with: @city
          # fill_in :state, with: state
          fill_in :zip, with: @zip
          fill_in :email, with: @email
          fill_in :password, with: @password
          fill_in :password_confirmation, with: @password

          click_on 'Register Now'
          expect(current_path).to eq("/users")
          expect(page).to have_content("State can't be blank")
        end

        it 'If I fill out the registration form; But include an email address already in the system; Then I am returned to the registration page; My details are not saved and I am not logged in; The form is filled in with all previous data except the email field and password fields; I see a flash message telling me the email address is already in use' do

          visit "/register"

          fill_in :name, with: @name
          fill_in :address, with: @address
          fill_in :city, with: @city
          fill_in :state, with: @state
          fill_in :zip, with: @zip
          fill_in :email, with: @existing_user.email
          fill_in :password, with: @password
          fill_in :password_confirmation, with: @password

          click_on 'Register Now'
          expect(current_path).to eq("/users")
          expect(page).to have_content("Email has already been taken")
        end
      end
    end
  end
end
