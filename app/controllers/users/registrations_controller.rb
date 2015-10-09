class Users::RegistrationsController < Devise::RegistrationsController
  def new
    super
  end

  def create
    p = params.require(:user).permit(:name, :email, :password, :password_confirmation)
    @user = User.new(p)
    if @user.valid?
      @user.save!
      redirect_to controller: '/gallery', action: 'index'
    else
      render action: 'new'
    end
  end
end
