require 'rails_helper'

RSpec.describe User, type: :model do

#  context "validation tests" do

  context "Validation email presence" do
    let(:user) {User.create(email: '', password:'123test' )}
    it "ensures email presence" do
      expect(user).to be_invalid
    end
  end

  context "validate emai patterns" do
    let(:user) {User.create(email: 'test@test', password:'123test' )}
    it "ensures email pattern" do
      expect(user).to be_invalid
    end
  end

  context "validate email creation" do
    let(:user) {User.create(email: 'test@test.com', password:'123test' )}
    it "ensures email created" do
      expect(user).to be_valid
    end
  end

  context "validate emai uniqueness" do
      let(:user1) {User.create(email: 'test@test.com', password:'123test' )}
      let(:user2) {User.create(email: 'test@test.com', password:'123test' )}
    it "ensures email uniqueness" do
      expect(user1).to be_valid
      expect(user2).to be_invalid
    end
  end

  context "validate email patterns" do
      let(:user) {User.create(email: 'test@test.com', password:'')}
    it "ensures password can't be blank" do
      expect(user).to be_invalid
    end
  end

  context "validate password" do
      let(:user) {User.create(email: 'test@test.com', password:'123456')}
    it "ensures password patterns must contain letters on create" do
      expect(user).to be_invalid
    end
end

  context "validate password" do
      let(:user) {User.create(email: 'test@test.com', password:'qwertyui')}
    it "ensures password must contain digits on create" do
      expect(user).to be_invalid
    end
  end

context "validate password" do
      let(:user) {User.create(email: 'test@test.com', password:'1qwer')}
    it "ensures password length 6 symbols min on create" do
      expect(user).to be_invalid
    end
  end

context "validate password" do
      let(:user) {User.create(email: 'test@test.com', password:'123456789qwer')}
    it "ensures password length 10 symbols max on create" do
      expect(user).to be_invalid
    end
end

context "validate password" do
      let(:user) {User.create(email: 'test@test.com', password:'123test')}
    it "ensures password length 6-10 symbols on create" do
      expect(user).to be_valid
    end
end

#  end #validations

describe "omniauth Google" do
before do
  Rails.application.env_config["omniauth.auth"] = OmniAuth.config.mock_auth[:google_oauth2]
end

it "creates or updates itself from an oauth hash" do
   User.find_or_create_from_auth_hash(Rails.application.env_config["omniauth.auth"])
   new_user = User.first

   expect(new_user.provider).to eq("google_oauth2")
   expect(new_user.uid).to eq("12345678910")
   expect(new_user.email).to eq("jesse@mountainmantechnologies.com")
   expect(new_user.first_name).to eq("Jesse")
   expect(new_user.last_name).to eq("Spevack")
   # expect(new_user.credentials.token).to eq("abcdefg12345")
   # expect(new_user.refresh_token).to eq("12345abcdefg")
   # expect(new_user.oauth_expires_at).to eq(auth[:credentials][:expires_at])

 end
end #Omniauth google

  describe "#full_name" do

      let(:user) { User.create(email: 'test@test.com', nickname: 'Test', first_name: 'First', last_name: 'Super', birth_day: '01-01-1900', password:'123test' ) }
      let(:blank_first) { User.create(email: 'admin@test.com', nickname: 'Blank', first_name: '', last_name: 'Super', password:'123test' ) }
      let(:blank_last) { User.create(email: 'admin2@test.com', nickname: 'Blank', first_name: 'Super', last_name: '', password:'123test' ) }

    it "should return full_name on fist_name and last_name presence" do
      expect(user.full_name).to eq (user.first_name + " " + user.last_name)
    end

    it "shoud return nul if first_name is blank" do
      expect(blank_first.full_name).to eq nil
    end

    it "shoud return nul if last_name is blank" do
      expect(blank_last.full_name).to eq nil
    end

  end #fill_name

  context "Time related birthdays" do
    let(:user) { User.create(email: 'test@test.com', nickname: 'Test', first_name: 'First', last_name: 'Super', birth_day: '01-01-1954', password:'123test' ) }
    let(:person1) {User.create(email:'tw@com.com',password:'123test',nickname: 'Twilight Sparkle', birth_day: Date.parse('2006-09-09')).reload}
    let(:person2) {User.create(email:'rd@com.com',password:'123test',nickname: 'Rainbow Dash',birth_day: Date.parse('2004-10-08')).reload}

  before :each do
    person1
    person2
   end

   it 'check #age correct' do
     travel_to(Date.parse('2011-09-09') + 4.hours) do
       expect(person1.age).to eq 5
       expect(person2.age).to eq 6
     end
   end

   it 'check #birthday_today? correctly' do
     travel_to(Date.parse('2011-09-09')) do
     expect(person1).to be_birthday_today
     expect(person2).not_to be_birthday_today
      end
   end

   it 'check .birthdays_today includes exect user' do
     travel_to(Date.parse('2018-01-01')) do
      birthdays_today = User.birthdays_today
     expect(birthdays_today).to include(user)
     expect(birthdays_today).not_to include(person1)
     expect(birthdays_today).not_to include(person2)
      end
   end


 end #Time related
end #User model
