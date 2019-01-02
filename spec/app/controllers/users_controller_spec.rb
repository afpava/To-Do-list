require 'rails_helper'

RSpec.describe UsersController, type: :controller do
      let(:user) { User.create(email: 'test@test.com', nickname: 'Test', first_name: 'First', last_name: 'Super', birth_day: '01-01-1954', password:'123test') }
      let(:person1) {User.create(email:'tw@com.com',password:'123test',nickname: 'Twilight Sparkle', birth_day: '2006-09-09').reload}
      let(:person2) {User.create(email:'rd@com.com',password:'123test',nickname: 'Rainbow Dash',birth_day: '2006-09-08').reload}

  describe 'GET #new' do

    context 'assigns a new User to @user ' do
      before do
        get :new
      end

      it 'if no current_user' do
        expect(assigns(:user)).to be_a_new(User)
      end
    end

    context 'should redirect to root_path' do
      before do
        allow(controller).to receive(:current_user) {user}
        user
        get :new
      end

      it{ expect(response).to redirect_to(root_path)}
    end

  end #GET #new

  describe 'GET index' do

    context 'should redirect to sign_in if not authorized' do
      before do
        user
        get :index
      end

      it{ expect(response).to render_template('sessions/first.html.erb') }
    end

    context 'should return current_user as a user' do
        before do
          allow(controller).to receive(:current_user) {user}
          user
          get :index
        end
        it{ expect(assigns(:user)).to eq (user) }
    end

  end #GET index

  describe 'GET #show' do
    # context 'should return all Users' do
    #     before do
    #       allow(controller).to receive(:current_user) {user}
    #       user
    #       get :show, params: { id: user.id }
    #     end
    #
    #     it{ expect(assigns(:users)).to include(user) }
    # end

    context 'should redirect to sign_in if not authorized' do
      before do
        user
        get :show, params: { id: user.id }
      end

      it{ expect(response).to render_template('sessions/first.html.erb') }
    end

     context 'should redirect to root_path if no admin or other user.id' do
      let(:post1) {user.posts.create(title:"This is test#{rand(1000)}", text:'Test message')}
       before do
         allow(controller).to receive(:current_user) {person1}
         user
         person1
         person2
       end
       it do
         get :show, params: { id: person2.id }
        expect(flash[:alert]).to eq 'You can view and edit only yours profile.'
        expect(response).to redirect_to(root_path)
      end
    end

  end #GET show

  describe 'GET #edit' do
    context 'should return exect user' do
        before do
          allow(controller).to receive(:current_user) {user}
          user
          get :edit, params: { id: user.id }
        end

        it{ expect(assigns(:user)).to eq (user) }
    end

    context 'should redirect to sign_in if not authorized' do
      before do
        user
        get :edit, params: { id: user.id }
      end

      it{ expect(response).to render_template('sessions/first.html.erb') }
    end

     context 'should redirect to root_path if no admin or other user.id' do
      let(:post1) {user.posts.create(title:"This is test#{rand(1000)}", text:'Test message')}
       before do
         allow(controller).to receive(:current_user) {person1}
         user
         person1
         person2
       end
       it do
         get :show, params: { id: person2.id }
        expect(flash[:alert]).to eq 'You can view and edit only yours profile.'
        expect(response).to redirect_to(root_path)
      end

    end

  end #GET edit



describe '#update' do

    before do
      allow(controller).to receive(:current_user) {user}
      person1
      user
    end


    context 'as a user' do
      subject { patch :update, params: { id: person1.id, user: user_params } }

      context 'with valid params' do
        let(:user_params) {user_params = { id: person1.id, nickname: 'Foo' } }

        it 'updates requested record' do
          subject
          expect(person1.reload.nickname).to eq(user_params[:nickname])
          expect(response).to redirect_to(root_path)
        end

      end

      context 'with invalid params' do
        let(:user_params) { user_params = {email: nil } }
        it do
           subject
           expect(response).to render_template(:edit)
         end
      end

    end

  end #PUT update





describe 'Delete #destroy' do
  before do
    allow(controller).to receive(:current_user) {person1}
    person1
  end

    context 'when params are valid' do

      it do
        expect{ delete :destroy, params: {id: person1.id} }.to change(User, :count).by(-1)
      end
      it do
        delete :destroy, params: {id: person1.id}
        expect(flash[:notice]).to eq 'user was successfully destroyed.'
      end

    end


   end # Delete #destroy

   describe 'POST users#create' do
     context 'should create a new user' do
       let(:user_params) { user_params = { nickname: "username#{rand(1000)}",
       email: "user#{rand(1000)}@factory.com",
       password: "Password1",
       password_confirmation: "Password1",

       } }
       before do
         user_params
       end

       it { expect { post(:create, params: { user: user_params }) }.to change(User, :count).by(1)}
       it do
         post(:create, params: { user: user_params })
         expect(response).to redirect_to(root_path)
       end

       it do
         post(:create, params: { user: user_params })
         expect(flash[:notice]).to eq 'Thank you for signing up!'
       end

     end

     context 'should render new template if params are wrong' do
       let(:user_wrong_params) { user_params = { nickname: "username#{rand(1000)}",
       email: "user#{rand(1000)}@factory.com",
       password: "Password123",
       password_confirmation: "Password123",
       } }

       before do
         user_wrong_params
       end

       it do
         post(:create, params: { user: user_wrong_params })
         expect(response).to render_template(:new)
       end

     end
   end #POST #create

end #Rspec
