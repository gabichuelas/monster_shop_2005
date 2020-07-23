RSpec.describe 'As a registered user' do
  before :each do
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

  describe 'When I visit my profile page and I click on the link to change my password; I see a form with fields for a new password, and a new password confirmation' do
    it 'When I fill in the same password in both fields; And I submit the form; Then I am returned to my profile page; And I see a flash message telling me that my password is updated' do

      visit "/profile"
      click_on 'Change Password'
      expect(current_path).to eq("/passwords/edit")

      fill_in :password, with: 'newpass'
      fill_in :password_confirmation, with: 'newpass'
      click_on 'Update Password'

      expect(current_path).to eq("/profile")
      expect(page).to have_content('Your password has been updated.')
    end

    it 'When I fill in a different password in both fields; And I submit the form; Then I am returned to the change password page; And I see a flash message telling me that my passwords dont match' do

      visit "/profile"
      click_on 'Change Password'
      expect(current_path).to eq("/passwords/edit")

      fill_in :password, with: 'newpass'
      fill_in :password_confirmation, with: 'wrongpass'
      click_on 'Update Password'
      # this is where test fails.
      # need to figure out how to make it a requirement
      # that the passwords match.
      expect(current_path).to eq("/passwords/edit")
      expect(page).to have_content('Your password has been updated.')
    end
  end
end
