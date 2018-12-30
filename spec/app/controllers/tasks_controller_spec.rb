require 'rails_helper'

RSpec.describe TasksController, type: :controller do
      let(:user) { User.create(email: 'test@test.com', nickname: 'Test', first_name: 'First', last_name: 'Super', birth_date: '01-01-1954', password:'123test',role:'admin' ) }
      let(:person1) {User.create(email:'tw@com.com',password:'123test',nickname: 'Twilight Sparkle', birth_date: '2006-09-09').reload}
      let(:person2) {User.create(email:'rd@com.com',password:'123test',nickname: 'Rainbow Dash',birth_date: '2006-09-08').reload}
      let(:post_params){post_params = {title:"This is test#{rand(1000)}", text:'Test message'}}
  #before { allow(controller).to receive(:current_user) {user} }

  describe 'GET #edit' do
    let(:post1) {user.tasks.create(post_params)}

    context 'should return exect user' do
      # let(:post_params){post_params = {text:'Test'}}
        before do
          allow(controller).to receive(:current_user) {user}
          person1
          post1

          get :edit, params: {user_id: post1.user.id, id: person1.id}
        end

        it{ expect(assigns(:post)).to eq (post1) }
    end

    context 'should return user if user has a birthday this month' do

        before do
          travel_to(Date.parse('2011-09-09'))
          allow(controller).to receive(:current_user) {user}
          user
          person1
          person2
          get :edit, params: { user_id: post1.user.id ,id: post1.id }
        end

        it '2 users must have birthday this month one should not' do
          expect(assigns(:birthdays)).to include(person2)
          expect(assigns(:birthdays)).to include(person1)
          expect(assigns(:birthdays)).not_to include(user)
        end

        it 'should return sorted by birth_date' do
          expect(assigns(:birthdays).first).to eq person2
        end

     end

  end #GET edit


  describe 'POST posts#create' do
    context 'should create a new post' do
      before do
        user
        post_params
      end

      it { expect { post(:create, params: { user_id: user.id, post: post_params }) }.to change(Post, :count).by(1)}
      it do
        post(:create, params: {user_id: user.id, post: post_params })
        expect(response).to redirect_to(root_path)
      end

      it do
        post(:create, params: {user_id: user.id, post: post_params })
        expect(flash[:notice]).to eq 'Post was successfully created.'
      end

    end

    context 'should render new template if params are wrong' do
      let(:post_params){post_params = {title: nil, text:'Test message'}}

      before do
        user
        post_params
      end

      it do
        post(:create, params: {user_id: user.id, post: post_params })
        expect(flash[:alert]).to eq 'Post was not created. Title and text could not be blank'

      end

    end
  end #POST #create


  describe 'PATCH#update' do
    let(:post_params){post_params = {title:"This is test#{rand(1000)}", text:'Test message'}}
    let(:post1) {person1.tasks.create(post_params)}
    subject { patch :update, params: {user_id: post1.user.id, id: person1.id, post: post_ch_params} }
      before do
        allow(controller).to receive(:current_user) {person1}
        person1
        user
        post1

      end


      context 'as a user' do

        context 'with valid params' do
          let(:post_ch_params) {post_params = {title: 'Foo', text: 'Foo' } }

          it 'updates requested record' do
            subject
            expect(post1.reload.text).to eq(post_ch_params[:text])
            expect(response).to redirect_to(root_path)

          end

        end

        context 'with invalid params' do
          let(:post_ch_params) {post_params = {title: nil, text: nil } }

          it do
             subject
             expect(response).to render_template(:edit)
           end
        end

      end


    end #PUT update

  describe 'Delete #destroy' do
  # describe 'DELETE destroy' do
    let(:post1) {person1.posts.create(post_params)}
    before do
      allow(controller).to receive(:current_user) {person1}
      person1
      post1

    end

      context 'when params are valid' do

        it do
          expect{ delete :destroy, params: {user_id: post1.user.id, id: post1.id} }.to change(Post, :count).by(-1)
        end
        it do
          delete :destroy, params: {user_id: post1.user.id, id: person1.id}
          expect(flash[:notice]).to eq 'Post was successfully destroyed.'
        end

      end

     end # Delete #destroy

end #Rspec
