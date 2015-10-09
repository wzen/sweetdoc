class UserController < ApplicationController
  def login

  end

  def login_modal

  end

  def show
  end

  def new
    @user = User.new
  end

  def confirm
    p = params.require(:user).permit(:name, :email, :password, :password_confirmation)
    @user = User.new(p)
    if @user.valid?
      @user.save!
      redirect_to controller: 'gallery', action: 'index'
    else
      redirect_to action: 'new'
    end
  end

  def edit
  end
end
