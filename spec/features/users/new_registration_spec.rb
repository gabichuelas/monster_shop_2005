RSpec.describe 'As a visitor' do
  describe 'When I click on the register link in the nav bar' do
    describe 'Then I am on the user registration page (\'register\')' do
      describe 'And I see a form where I input the following data: name, street address, city, state, zip code, email address, password, password confirmation' do

        it 'When I fill in this form completely, and with a unique email address, my details are saved in the db, then I am logged in as a registered user, I am taken to my profile page (\'/profile\'), I see a flash message indicating I am now registered and logged in' do

          visit "/"
          click_on 'Register'
          expect(current_path).to eq("/register")

          fill_in :name, with: name
          fill_in :address, with: address
          fill_in :city, with: city
          fill_in :state, with: state
          fill_in :zip, with: zip
          fill_in :email, with: email
          fill_in :password, with: password
          fill_in :password_confirmation, with: password

          click_on 'Register Now'
          new_user = User.last

          expect(current_path).to eq("/profile")

          expect(page).to have_content("You are now registered and logged in")
        end

        it 'And I do not fill in this form completely; I am returned to the registration page; And I see a flash message indicating that I am missing required fields' do

          visit "/register"

          fill_in :name, with: name
          fill_in :address, with: address
          fill_in :city, with: city
          # fill_in :state, with: state
          fill_in :zip, with: zip
          fill_in :email, with: email
          fill_in :password, with: password
          fill_in :password_confirmation, with: password

          click_on 'Register Now'
          expect(current_path).to eq("/register")
          expect(page).to have_content("State can not be blank")
        end

        it 'If I fill out the registration form; But include an email address already in the system; Then I am returned to the registration page; My details are not saved and I am not logged in; The form is filled in with all previous data except the email field and password fields; I see a flash message telling me the email address is already in use' do

          # create a User fixture here so we can use the same email address to test this error
          existing_user = User.create!()

          visit "/register"

          fill_in :name, with: name
          fill_in :address, with: address
          fill_in :city, with: city
          fill_in :state, with: state
          fill_in :zip, with: zip
          fill_in :email, with: existing_user.email
          fill_in :password, with: password
          fill_in :password_confirmation, with: password

          click_on 'Register Now'
          expect(current_path).to eq("/register")
          expect(page).to have_content("This email is already in use")
        end
      end
    end
  end
end
