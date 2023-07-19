require 'rails_helper'

RSpec.feature "UserSignUps", type: :feature do
  scenario "user signs up successfully" do
    visit new_user_registration_path
    fill_in "user_username", with: "example_user"
    fill_in "user_firstname", with: "John"
    fill_in "user_lastname", with: "Doe"
    fill_in "user_email", with: "example_user@example.com"
    fill_in "user_birthdate", with: "1980-01-01"
    fill_in "user_password", with: "password"
    fill_in "user_password_confirmation", with: "password"
    click_button "Sign up"

    expect(page).to have_content("Welcome")
  end

  scenario "user attempts to sign up with already-taken email" do
    existing_user = create(:user, password: "password")
    visit new_user_registration_path
    fill_in "user_username", with: "new_user"
    fill_in "user_firstname", with: "New"
    fill_in "user_lastname", with: "User"
    fill_in "user_email", with: existing_user.email
    fill_in "user_birthdate", with: "1980-01-01"
    fill_in "user_password", with: "password"
    fill_in "user_password_confirmation", with: "password"
    click_button "Sign up"

    expect(page).to have_content("Email has already been taken")
  end

  scenario "user attempts to sign up with invalid data" do
    visit new_user_registration_path
    fill_in "user_username", with: "" # empty username
    fill_in "user_firstname", with: "John3" # non-alphabetic characters
    fill_in "user_lastname", with: "Doe3" # non-alphabetic characters
    fill_in "user_email", with: "example_user" # not a valid email
    fill_in "user_birthdate", with: "1980-01-01"
    fill_in "user_password", with: "pass" # password too short
    fill_in "user_password_confirmation", with: "pass"
    click_button "Sign up"

    expect(page).to have_content("prohibited this user from being saved")
  end

  scenario "user attempts to sign up with improperly formatted email" do
    visit new_user_registration_path
    fill_in "user_username", with: "new_user"
    fill_in "user_firstname", with: "New"
    fill_in "user_lastname", with: "User"
    fill_in "user_email", with: "exampleuser" # not a valid email
    fill_in "user_birthdate", with: "1980-01-01"
    fill_in "user_password", with: "password"
    fill_in "user_password_confirmation", with: "password"
    click_button "Sign up"

    expect(page).to have_content("Email is invalid")
  end

  scenario "user attempts to sign up with password and password confirmation not matching" do
    visit new_user_registration_path
    fill_in "user_username", with: "new_user"
    fill_in "user_firstname", with: "New"
    fill_in "user_lastname", with: "User"
    fill_in "user_email", with: "example_user@example.com"
    fill_in "user_birthdate", with: "1980-01-01"
    fill_in "user_password", with: "password"
    fill_in "user_password_confirmation", with: "password123" # password and password confirmation do not match
    click_button "Sign up"

    expect(page).to have_content("Password confirmation doesn't match Password")
  end

  scenario "user attempts to sign up with short username" do
    visit new_user_registration_path
    fill_in "user_username", with: "new" # short username
    fill_in "user_firstname", with: "New"
    fill_in "user_lastname", with: "User"
    fill_in "user_email", with: "example_user@example.com"
    fill_in "user_birthdate", with: "1980-01-01"
    fill_in "user_password", with: "password"
    fill_in "user_password_confirmation", with: "password"
    click_button "Sign up"
  
    expect(page).to have_content("Username is too short (minimum is 6 characters)")
  end
  
  scenario "user attempts to sign up with long username" do
    visit new_user_registration_path
    fill_in "user_username", with: "new_user1234567890" # long username
    fill_in "user_firstname", with: "New"
    fill_in "user_lastname", with: "User"
    fill_in "user_email", with: "example_user@example.com"
    fill_in "user_birthdate", with: "1980-01-01"
    fill_in "user_password", with: "password"
    fill_in "user_password_confirmation", with: "password"
    click_button "Sign up"

    expect(page).to have_content("Username is too long (maximum is 15 characters)")
  end
end
