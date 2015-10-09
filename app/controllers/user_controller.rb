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
    p = params.require(:user).permit(:name, :email, :password)
    @user = User.new(p)
    if @user.valid?
      @user.save!
      render template: 'gallery/index', layout: 'gallery'
    else
      render action: 'new'
    end
  end

  def edit
  end
end
