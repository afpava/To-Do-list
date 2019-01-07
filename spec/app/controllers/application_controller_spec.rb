require 'rails_helper'

RSpec.describe ApplicationController, :type => :controller do

    controller do

     def index
        @current_user = current_user
        render text: 'Hello World'
      end
    end

    let(:user) { User.create(email: 'test@test.com', nickname: 'Test', first_name: 'First', last_name: 'Super', birth_day: '01-01-1954', password:'123test' ) }

   describe '#current_user' do

     # context 'with user logged in' do
     #
     #   before do
     #     user
     #     get :index
     #   end

       it 'assigns the current_user' do
         expect(assigns(:current_user)).to eq(user)
     end
     end

     context 'without user logged in' do

       it 'current_user be nil' do
         get :index
         expect(assigns(:current_user)).to be_nil
       end
     end

     context "can't find the user" do

       before do
         session[:user_id] = '#77'
         get :index
       end

       it 'current_user be nil' do
         expect(assigns(:current_user)).to be_nil
         binding.pry
       end

       it 'unsets the session[:user_id]' do
         expect(session[:user_id]).to be_nil
       end
     end

 end
end
