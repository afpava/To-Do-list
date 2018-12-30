class SessionsController < ApplicationController
skip_before_action :require_login

  def index
    #redirect_to login_path
  end

  def new
    redirect_to root_path
  end

  def create
    if request.env["omniauth.auth"].nil?

        user = User.find_by(email: params[:email].downcase)

       if user && user.authenticate(params[:password])
         session[:user_id] = user.id
         redirect_to root_path

       else
         flash.now.alert = 'Email or password is invalid'
         render :new
       end

     else

       user = User.find_or_create_from_auth_hash(request.env["omniauth.auth"])
       session[:user_id] = user.id
       redirect_to root_path
     end
   end

def destroy
  session[:user_id] = nil
  redirect_to root_url, notice: "Logged out!"
end

private
  def session_params
      params.require(:session).permit(:email, :password)
  end
end
