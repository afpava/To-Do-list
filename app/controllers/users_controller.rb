class UsersController < ApplicationController
  skip_before_action :require_login, only: [:new, :create]
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :authorize_admin, only: [:show, :edit]
      def new
          if current_user
            redirect_to root_path, alert: 'You are signed in, logout first.'
          else
            @user = User.new
          end
      end

      def index
        # @users = User.all
        @user = current_user
      end

      def edit
          @user = User.find(params[:id])
      end

      def update
        if @user.update(user_params)
          redirect_to root_path, notice: 'Profile was successfully updated.'
        else
          render :edit
        end
      end

      def destroy
        @user.destroy
         redirect_to root_url, notice: 'user was successfully destroyed.'
      end

      def create
          @user = User.new(user_params)
            if @user.save
          session[:user_id] = @user.id
          redirect_to root_path , notice: "Thank you for signing up!"
        else
          render "new"
        end
      end

    private

      def set_user
        @user = User.find(params[:id])
      end


      def user_params
          params.require(:user).permit(:nickname, :last_name, :first_name, :birth_day, :gender, :provider, :country, :city, :avatar ,:email, :password, :password_confirmation)
      end

end
