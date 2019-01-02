require 'rails_helper'

RSpec.describe TasksController, type: :controller do
      let(:user) { User.create(email: 'test@test.com', nickname: 'Test', first_name: 'First', last_name: 'Super', birth_day: '01-01-1954', password:'123test' ) }
      let(:person1) {User.create(email:'tw@com.com',password:'123test',nickname: 'Twilight Sparkle', birth_day: '2006-09-09').reload}
      let(:person2) {User.create(email:'rd@com.com',password:'123test',nickname: 'Rainbow Dash',birth_day: '2006-09-08').reload}
      let(:task_params){title_params = {title:"This is test#{rand(1000)}", text:'Test message'}}
  #before { allow(controller).to receive(:current_user) {user} }

  describe 'GET #edit' do
    let(:task1) {user.tasks.create(task_params)}

    context 'should return exect user task' do
      # let(:task_params){task_params = {text:'Test'}}
        before do
          allow(controller).to receive(:current_user) {user}
          person1
          task1

          get :edit, params: {user_id: task1.user.id, id: person1.id}
        end

        it{ expect(assigns(:task)).to eq (task1) }
    end

    # context 'should return user if user has a birthday this month' do
    #
    #     before do
    #       travel_to(Date.parse('2011-09-09'))
    #       allow(controller).to receive(:current_user) {user}
    #       user
    #       person1
    #       person2
    #       get :edit, params: { user_id: task1.user.id ,id: task1.id }
    #     end
    #
    #     it '2 users must have birthday this month one should not' do
    #       expect(assigns(:birthdays)).to include(person2)
    #       expect(assigns(:birthdays)).to include(person1)
    #       expect(assigns(:birthdays)).not_to include(user)
    #     end
    #
    #     it 'should return sorted by birth_date' do
    #       expect(assigns(:birthdays).first).to eq person2
    #     end
    #
    #  end

  end #GET edit


  describe 'task tasks#create' do
    context 'should create a new task' do
      before do
        user
        task_params
      end

      it { expect { post(:create, params: { user_id: user.id, task: task_params }) }.to change(Task, :count).by(1)}
      it do
        post(:create, params: {user_id: user.id, task: task_params })
        expect(response).to redirect_to(root_path)
      end

      it do
        post(:create, params: {user_id: user.id, task: task_params })
        expect(flash[:notice]).to eq 'task was successfully created.'
      end

    end

    context 'should render new template if title is blank' do
      let(:task_params){task_params = {title: nil, text:'Test message'}}

      before do
        user
        task_params
      end

      it do
        post(:create, params: {user_id: user.id, task: task_params })
        expect(flash[:alert]).to eq 'Title can\'t be blank'

      end

    end

    context 'should render new template if text is blank' do
      let(:task_params){task_params = {title: 'Test', text: nil}}

      before do
        user
        task_params
      end

      it do
        post(:create, params: {user_id: user.id, task: task_params })
        expect(flash[:alert]).to eq 'Text can\'t be blank'

      end

    end

    context 'should render new template if params are blank' do
      let(:task_params){task_params = {title: nil, text: nil}}

      before do
        user
        task_params
      end

      it do
        post(:create, params: {user_id: user.id, task: task_params })
        expect(flash[:alert]).to eq 'Title can\'t be blank. Text can\'t be blank'

      end

    end
  end #task #create

  describe 'PATCH#complete' do
    let(:task_params){task_params = {title:"This is test#{rand(1000)}", text:'Test message'}}
    let(:task1) {person1.tasks.create(task_params)}
      before do
        allow(controller).to receive(:current_user) {person1}
        person1
        user
        task1

      end


      context 'as a user' do

        context 'with valid params' do
          let(:task_ch_params) { task_ch_params ={completed: true} }

          it 'updates requested record completed: true' do
            # subject
            patch :complete, params: {user_id: task1.user.id, id: person1.id, completed: true }
            expect(task1.reload.completed).to eq(task_ch_params[:completed])
            expect(response).to redirect_to(root_path)
            expect(flash[:notice]).to eq 'Todo item completed'

          end

          it 'updates requested record completed: false' do
            # subject
            patch :complete, params: {user_id: task1.user.id, id: person1.id, completed: false }
            expect(task1.reload.completed).to eq false
            expect(response).to redirect_to(root_path)
            expect(flash[:notice]).to eq 'Todo item unchecked'

          end


        end
      #
      #   context 'with invalid params' do
      #     let(:task_ch_params) {task_params = {title: nil, text: nil } }
      #
      #     it do
      #        subject
      #        expect(response).to render_template(:edit)
      #      end
      #   end
      #
      end


    end #PATCH complete




  describe 'PATCH#update' do
    let(:task_params){task_params = {title:"This is test#{rand(1000)}", text:'Test message'}}
    let(:task1) {person1.tasks.create(task_params)}
    subject { patch :update, params: {user_id: task1.user.id, id: person1.id, task: task_ch_params} }
      before do
        allow(controller).to receive(:current_user) {person1}
        person1
        user
        task1

      end


      context 'as a user' do

        context 'with valid params' do
          let(:task_ch_params) {task_params = {title: 'Foo', text: 'Foo' } }

          it 'updates requested record' do
            subject
            expect(task1.reload.text).to eq(task_ch_params[:text])
            expect(response).to redirect_to(root_path)

          end

        end

        context 'with invalid params' do
          let(:task_ch_params) {task_params = {title: nil, text: nil } }

          it do
             subject
             expect(response).to render_template(:edit)
           end
        end

      end


    end #PUT update

  describe 'Delete #destroy' do
  # describe 'DELETE destroy' do
    let(:task1) {person1.tasks.create(task_params)}
    before do
      allow(controller).to receive(:current_user) {person1}
      person1
      task1

    end

      context 'when params are valid' do

        it do
          expect{ delete :destroy, params: {user_id: task1.user.id, id: task1.id} }.to change(Task, :count).by(-1)
        end
        it do
          delete :destroy, params: {user_id: task1.user.id, id: person1.id}
          expect(flash[:notice]).to eq 'task was successfully destroyed.'
        end

      end

     end # Delete #destroy

end #Rspec
