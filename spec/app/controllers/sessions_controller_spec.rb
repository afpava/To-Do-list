require 'rails_helper'

RSpec.describe SessionsController, type: :controller do

  # let(:user) { User.make(:username => 'bob') }
  let(:user) { User.create(email: 'test@test.com', nickname: 'Test', first_name: 'First', last_name: 'Super', birth_date: '01-01-1954', password:'123test',role:'admin' ) }
  let(:user_params) { params = {email: 'test@test.com',  password: '123test'} }

  describe '#create' do
    it 'should redirect to the home page' do
      get :new
      expect(response).to redirect_to(root_path)
    end
  end

  describe '#create' do
    context 'authenticate fail' do
      # before(:each) { allow(controller).to receive(:require_login) {nil} }

      it 'session[:user_id] should == user.id' do
        post :create
      expect( session[:user_id] ).to be_nil
      end

      it 'should render_template :new' do
        post :create
        expect(response).to render_template :new
      end

      it 'flash.now[:alert] should be set to failure' do
        post :create
        expect(flash.now[:alert]).to eq 'Email or password is invalid'
      end
    end

    context 'authenticate successfully' do
      before do
        user
        post :create, params: {email: 'test@test.com',  password: '123test'}
      end

      it 'should redirect to home page' do
        expect(response).to redirect_to(root_path)
      end

      it 'session[:user_id] should == user.id' do
        expect(session[:user_id]).to eq user.id
      end

    end
  end # sessios#create

describe "#destroy" do
  before do
    user
    post :create, params: {email: 'test@test.com',  password: '123test'}
  end

  it "should clear the session" do
    expect(session[:user_id]).not_to be_nil
    delete :destroy
    expect(session[:user_id]).to be_nil
  end

  it "should redirect to the home page" do
    delete :destroy
    expect(response).to redirect_to(root_path)
  end

  it 'flash.now[:alert] should be set to Logge out' do
    delete :destroy
    expect(flash.now[:notice]).to eq 'Logged out!'
  end
end #sessios#destroy

end #Rspec
