class HomeController < ApplicationController
  def index
    @users = User.all
    @users = User.paginate(page: params[:page], per_page: 10)
  end
end
