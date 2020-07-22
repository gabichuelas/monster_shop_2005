RSpec.describe 'As a merchant employee' do
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
    end

    it 'Plus the following link to my merchant dashboard \"/merchant\"' do

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant)
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
  end
end
