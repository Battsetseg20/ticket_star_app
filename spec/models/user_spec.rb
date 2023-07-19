require 'rails_helper'

RSpec.describe User, type: :model do
  subject { build(:user) }

  it { should validate_presence_of(:email) }
  it { should validate_uniqueness_of(:email).case_insensitive }
  it { should validate_presence_of(:firstname) }
  it { should validate_presence_of(:lastname) }
  it { should validate_presence_of(:username) }
  it { should validate_uniqueness_of(:username).case_insensitive }
  it { should allow_value('Margherita').for(:username) }
  it { should_not allow_value('Margherita###').for(:username) }

  it "validates that firstname contains only letters" do
    user = build(:user, firstname: 'John3')
    expect(user).not_to be_valid
    expect(user.errors[:firstname]).to include("should only contain letters, spaces, hyphens, and apostrophes")
  end

  it "validates that lastname contains only letters" do
    user = build(:user, lastname: 'Doe3')
    expect(user).not_to be_valid
    expect(user.errors[:lastname]).to include("should only contain letters, spaces, hyphens, and apostrophes")
  end

  it "validates the email format" do
    user = build(:user, email: 'invalid')
    expect(user).not_to be_valid
    expect(user.errors[:email]).to include('is invalid')
  end

  describe 'username validations' do 
    it "validates minimum length of username" do
      user = build(:user, username: 'john')
      expect(user).not_to be_valid
      expect(user.errors[:username]).to include('is too short (minimum is 6 characters)')
    end
  
    it "validates maximum length of username" do
      user = build(:user, username: 'johnnyappleseed123')
      expect(user).not_to be_valid
      expect(user.errors[:username]).to include('is too long (maximum is 15 characters)')
    end
  
    it "validates alphanumeric characters in the username" do
      user = build(:user, username: 'john!')
      expect(user).not_to be_valid
      expect(user.errors[:username]).to include("is too short (minimum is 6 characters)", "should only contain letters and numbers")
    end

    it 'validates that username is not all the same character' do
      ['aaaaaaa', '1111111'].each do |invalid_username|
        subject.username = invalid_username
        expect(subject).not_to be_valid
        expect(subject.errors[:username]).to include('cannot be all the same character')
      end
    end

    it 'validates that username can be composed of different characters' do
      user = build(:user, username: 'abcdefg', password: "password")
      expect(user).to be_valid
    end
  end

  describe 'birthdate validations' do
    it 'validates the birthdate format' do
      user = build(:user, birthdate: '15/07/2003', password: "password")
      expect(user).to be_valid
    end

    it 'validates that the birthdate is not in the future' do
      user = build(:user, birthdate: (Date.today + 1.day).strftime('%d/%m/%Y'), password: "password")
      expect(user).not_to be_valid
      expect(user.errors[:birthdate]).to include('cannot be in the future')
    end

    it 'validates that the user is at least 18 years old' do
      user = build(:user, birthdate: 16.years.ago.to_date.strftime('%d/%m/%Y'), password: "password")
      expect(user).not_to be_valid
      expect(user.errors[:birthdate]).to include('must be at least 18 years old')
    end
  
    it 'validates that the user is 18 years old or older' do
      user = build(:user, birthdate: 19.years.ago.to_date.strftime('%d/%m/%Y'), password: "password")
      expect(user).to be_valid
    end
  end
end
