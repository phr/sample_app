class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    @title = @user.name # Rails 3 escapes this automatically.
  end
  def new
    @title = "Sign up"
  end
end
