RSpec.describe 'As a merchant employee' do
  before :each do
    @merchant_employee = User.create!(name: "Jose", address: "789 Jkl St.", city: "Denver", state: "Colorado", zip: "80202", email: "example4@hotmail.com", password: "qwer", role: 1)

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant_employee)
  end

  describe 'When I visit my merchant dashboard' do
    it 'I see a link to view my own items; When I click that link; My URI route should be "/merchant/items"' do

      visit "/merchant"
      click_on "View My Items"
      expect(current_path).to eq("/merchant/items")
    end
  end
end
