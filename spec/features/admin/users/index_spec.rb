RSpec.describe 'As an admin user' do
  before :each do
    #
    @meg = Merchant.create!(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)

    @admin = User.create!(name: "Admin User", address: "Admin Way.", city: "Denver", state: "Colorado", zip: "80202", email: "admin@hotmail.com", password: "qwer", role: 2)

    @employee = User.create!(name: "Merchant Employee", address: "Legend St.", city: "Gainesville", state: "FL", zip: "80202", email: "employee@hotmail.com", password: "qwer", role: 1, merchant_id: @meg.id)

    @user = User.create!(name: "Regular User", address: "Garbled St.", city: "Denver", state: "Colorado", zip: "80202", email: "user@hotmail.com", password: "qwer", role: 0)

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@admin)
  end

  describe 'When I click the "Users" link in the nav (only visible to admins)' do
    it 'Then my current URI route is "/admin/users"; Only admin users can reach this path.' do
      #
      visit "/"
      click_on "All Users"
      expect(current_path).to eq("/admin/users")

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)

      visit "/admin/users"
      expect(current_path).to eq("/public/404")
    end

    it 'I see all users in the system; Each user\'s name is a link to a show page for that user ("/admin/users/5")' do
      #
      visit "/admin/users"

      within "#user-#{@user.id}" do
        expect(page).to have_link("Regular User")
      end

      within "#user-#{@employee.id}" do
        expect(page).to have_link("Merchant Employee")
      end

      within "#user-#{@admin.id}" do
        expect(page).to have_link("Admin User")
      end
    end

    it 'Next to each user\'s name is the date they registered; Next to each user\'s name I see what type of user they are' do
      #
      visit "/admin/users"

      within "#user-#{@user.id}" do
        expect(page).to have_content("Registered on: #{@user.created_at}")
        expect(page).to have_content("Type: #{@user.created_at}")
      end

      within "#user-#{@employee.id}" do
        expect(page).to have_content("Registered on: #{@employee.created_at}")
        expect(page).to have_content("Type: #{@employee.created_at}")
      end

      within "#user-#{@admin.id}" do
        expect(page).to have_content("Registered on: #{@admin.created_at}")
        expect(page).to have_content("Type: #{@admin.created_at}")
      end
    end
  end
end
