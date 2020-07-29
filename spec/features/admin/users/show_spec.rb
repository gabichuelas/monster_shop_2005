RSpec.describe 'As an admin user' do
  before :each do
    #
    @meg = Merchant.create!(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)

    @admin = User.create!(name: "Admin User", address: "Admin Way.", city: "Denver", state: "Colorado", zip: "80202", email: "admin@hotmail.com", password: "qwer", role: 2)

    @employee = User.create!(name: "Merchant Employee", address: "Legend St.", city: "Gainesville", state: "FL", zip: "80202", email: "employee@hotmail.com", password: "qwer", role: 1, merchant_id: @meg.id)

    @user = User.create!(name: "Regular User", address: "Garbled St.", city: "Denver", state: "Colorado", zip: "80202", email: "user@hotmail.com", password: "qwer", role: 0)

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@admin)
  end

  describe 'When I visit a user\'s profile page ("/admin/users/5")' do
    it 'I see the same information the user would see themselves; I do not see a link to edit their profile' do
      #
      visit "/admin/users/#{@user.id}"

      expect(page).to have_content('Regular User')
      expect(page).to have_content('Garbled St.')
      expect(page).to have_content('Denver, CO')
      expect(page).to have_content('80202')
      expect(page).to have_content('user@hotmail.com')
      expect(page).to have_link("Change Password")
    end
  end
end
