class UsersController < ApplicationController
  #wrap_parameters :user, include: [:name, :password, :password_confirmation]
  skip_before_action :require_login, only: [:new, :create]
  #before_action :user_params, only: [:edit]
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
        @users = User.all
        @user = current_user
        @birthdays = User.birthdays_this_month.sort_by{|p| p.birth_date.day}
        @first_birthday = User.birthdays_today.first
        #binding.pry
        # if request.referrer == signup_url
        #   redirect_to signup_path
        # end
      end

      def show
        @users = User.all
        @birthdays = User.birthdays_this_month.sort_by{|p| p.birth_date.day}
      end

      def edit
          @user = User.find(params[:id])
          @birthdays = User.birthdays_this_month.sort_by{|p| p.birth_date.day}
      end

      def update
        # binding.pry
        if @user.update(user_params)
          redirect_to root_path, notice: 'Profile was successfully updated.'
        else
          render :edit
        end
      end

      def destroy
         # binding.pry
        @user.destroy
         redirect_to root_url, notice: 'user was successfully destroyed.'
      end

      def create
          #session[:return_to] = nil
          @user = User.new(user_params)
            if @user.save
          session[:user_id] = @user.id
          #redirect_to root_url, notice: "Thank you for signing up!"
          redirect_to root_path , notice: "Thank you for signing up!"
                #binding.pry
        else
          render "new"
        end
      end

    private

      def set_user
        @user = User.find(params[:id])
      end


      def user_params
          params.require(:user).permit(:nickname, :last_name, :first_name, :birth_date, :gender, :provider, :country, :city, :avatar ,:email, :password, :password_confirmation)
      end

end
