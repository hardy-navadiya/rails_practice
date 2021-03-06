class UsersController < ApplicationController
  include SessionsHelper
  
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      # log_in @user
      UserMailer.account_activation(@user).deliver_now
      flash[:success] = "Please check your email to activate your account"
      redirect_to @user
    else
      flash[:danger] = "Something went wrong"
      render 'new'
    end
  end

  def show
    @user = User.find(params[:id])
    # @user = User.find(session[:user_id])
  end

  # edit user 
  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:success] = "profile Updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  # user delete
  def destroy 
    User.find(params[:id]).destroy
    flash[:danger] = "delete"
    redirect_to users_url
  end

  private 
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = "Please log in."
      redirect_to signin_url
    end
  end

  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_url) unless current_user?(@user)
  end

  # confirms an admin user 
  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end
end
