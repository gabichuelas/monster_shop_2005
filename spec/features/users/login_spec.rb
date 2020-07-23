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
    end
  end
