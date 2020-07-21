RSpec.describe 'As a default user' do
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
    end

    it 'Plus the following links: /profile, /logout' do

      visit '/'
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@existing_user)

      within 'nav' do
        expect(page).to have_content('Home')
        expect(page).to have_content('All Items')
        expect(page).to have_content('All Merchants')
        expect(page).to have_content('Cart: 0')

        expect(page).to_not have_content('Login')
        expect(page).to_not have_content('Register')

        expect(page).to have_content('Profile')
        expect(page).to have_content('Logout')

        expect(page).to have_content('Logged in as Norma Lopez')
      end
    end
  end
end
