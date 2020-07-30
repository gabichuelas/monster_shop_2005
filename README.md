# Monster Shop
### BE Mod 2 Week 4/5 Group Project

<p align="center">
  <a href="https://sheltered-brook-43399.herokuapp.com/">View our Monster Shop 2005</a>
 </p>

 <p align="center">
   <a href="https://github.com/Ashkanthegreat/monster_shop_2005">Clone and Contribute to Monster Shop</a>
  </p>

### Team
<p>
<a href="https://github.com/IamNorma">Norma Lopez</a>
</p>
<p>
<a href="https://github.com/gabichuelas">Gaby Mendez</a>
</p>
<p>
<a href="https://github.com/Jonathan-M-Wilson">Jonathan Wilson</a>
</p>
<p>
<a href="https://github.com/Ashkanthegreat"> Ashkan Abbasi</a>
</p>

## Background and Description

"Monster Shop" is a fictitious e-commerce platform where users can register to place items into a shopping cart and 'check out'. Users who work for a merchant can mark their items as 'fulfilled'; the last merchant to mark items in an order as 'fulfilled' will be able to get "shipped" by an admin. Each user role will have access to some or all CRUD functionality for application models.

[Original Monster Shop Project Spec](https://github.com/turingschool-examples/monster_shop_2005/blob/master/README.md)

### Gems
- rspec-rails
- capybara
- launchy
- pry
- simplecov
- shoulda-matchers
- factory_bot_rails
- orderly


## Requirements

- Rails 5.1.x
- PostgreSQL
- 'bcrypt' for authentication
- all controller and model code are tested

## Implementation Instructions

- Clone down repo
- Run `bundle install` & `bundle update` if necessary
- Run `rails db:{drop,create,migrate,seed}`
- Run `bundle exec rspec` and you should be seeing 214 passing examples/specs

## Bugs / Retro

When editing a User Profile, although it is not possible to change a password on this page (as there is no visible password input field), the existing password is getting overridden behind the scenes and effectively changing the user's password unintentionally. This is because the hidden input field is being prepopulated with the existing password hash, and _bcrypt_ basically re-encrypts the encryption.

While investigating this issue, we found out that the best way to keep password / User login functionality separate from the rest of the profile (and not run into this problem) is by creating a separate join table of sorts, to associate User IDs with hashed passwords, instead of the `PasswordsController` we're using currently.

## Code References

**UsersController**<br>
Edit User Profile with #update

```ruby
class UsersController < ApplicationController
  def update
    current_user.update(user_params)
    if current_user.valid?
      redirect_to "/profile"
    else
      flash[:errors] = current_user.errors.full_messages
      redirect_to "/users/edit"
    end
  end

  private

  def user_params
    params.permit(:name, :address, :city, :state, :zip, :email, :password, :password_confirmation, :merchant_id)
  end
end
```

**PasswordsController**<br>
Change user password with #update

```ruby
class PasswordsController < ApplicationController
  before_action :current_user

  def update
    current_user.update(pass_params)
    if current_user.authenticate(params[:password_confirmation])
      redirect_to "/profile"
      flash[:success] = 'Your password has been updated.'
    else
      flash[:errors] = current_user.errors.full_messages
      redirect_to "/passwords/edit"
    end
  end

  private

  def pass_params
    params.permit(:password, :password_confirmation)
  end
end
```

**Users#Edit**
Note hidden password input fields.

```ruby
<h1>Edit Your Profile</h1>
<%= form_tag "/users/edit", method: :patch do %>
  <%= text_field_tag :name, current_user.name, placeholder: 'Name' %><br>
  <%= text_field_tag :address, current_user.address, placeholder: 'Address' %><br>
  <%= text_field_tag :city, current_user.city, placeholder: 'City' %><br>
  <%= text_field_tag :state, current_user.state, placeholder: 'State' %><br>
  <%= text_field_tag :zip, current_user.zip, placeholder: 'Zip' %><br>
  <%= text_field_tag :email, current_user.email, placeholder: 'Email' %><br>
  <%= hidden_field_tag :password, current_user.password_digest %><br>
  <%= hidden_field_tag :password_confirmation, current_user.password_digest %><br>
  <%= submit_tag 'Save Profile' %>
<% end %>
```
