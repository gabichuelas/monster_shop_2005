RSpec.describe 'Admin merchant index page' do
  before(:each) do
    @existing_admin = User.create!(name: "Chuck Norris",
                                  address: "Legend St.",
                                  city: "Denver",
                                  state: "Colorado",
                                  zip: "80202",
                                  email: "example_admin@hotmail.com",
                                  password: "qwer",
                                  role: 2)

    @meg = Merchant.create!(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
    @brian = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)

    @tire = @meg.items.create!(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
    @pull_toy = @brian.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
    @dog_bone = @brian.items.create(name: "Dog Bone", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", inventory: 21)

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@existing_admin)
  end

  describe 'As an Admin user' do
    describe "When I visit the admin's merchant index page" do
      it 'I see a \"disable\" button next to any merchants who are not yet disabled' do
        visit '/merchants'

        within "#merchant-#{@meg.id}" do
          expect(page).to have_button('Disable')
        end

        within "#merchant-#{@brian.id}" do
          expect(page).to have_button('Disable')
        end
      end

      describe "When I click on the \"disable\" button" do
        it 'I\'m returned to admin\'s merchant index and a flash message informs me that merchant\'s account is now disabled' do
          visit '/merchants'

          within "#merchant-#{@meg.id}" do
            click_button('Disable')
            expect(current_path).to eq('/merchants')
          end

          expect(page).to have_content('This merchant\'s account is now disabled.')

          within "#merchant-#{@meg.id}" do
            expect(page).to_not have_button('Disable')
          end
        end
      end

      describe 'When I visit the merchant index page' do
        it 'And I click on the "disable" button for an enabled merchant; Then all of that merchant\'s items should be deactivated' do

          visit "/merchants"

          within "#merchant-#{@brian.id}" do
            click_button('Disable')
          end

          expect(@brian.items.all? {|item| item.active?}).to eq(false)
        end
      end

      describe "When I click on the \"enable\" button" do
        it 'I\'m returned to admin\'s merchant index and a flash message informs me that merchant\'s account is now enabled' do
          visit '/merchants'

          within "#merchant-#{@meg.id}" do
            click_button('Disable')
            expect(current_path).to eq('/merchants')
          end

          within "#merchant-#{@meg.id}" do
            click_button('Enable')
            expect(current_path).to eq('/merchants')
          end

          expect(page).to have_content('This merchant\'s account is now enabled.')

          within "#merchant-#{@meg.id}" do
            expect(page).to have_button('Disable')
          end
        end
      end

      describe 'When I visit the merchant index page' do
        it 'And I click on the "enable" button for an disabled merchant; Then all of that merchant\'s items should be activated' do

          visit "/merchants"

          within "#merchant-#{@brian.id}" do
            click_button('Disable')
            expect(current_path).to eq('/merchants')
          end

          within "#merchant-#{@brian.id}" do
            click_button('Enable')
            expect(current_path).to eq('/merchants')
          end

          expect(@brian.items.all? {|item| item.active?}).to eq(true)
        end
      end
    end
  end
end
