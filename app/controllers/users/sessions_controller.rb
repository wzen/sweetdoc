class Users::SessionsController < Devise::SessionsController
  def new
    super
  end

  def create
    # login
    super
    set_current_user(current_user)
    @do_login = true
  end

  def destroy
    # logout
    super
    destroy_current_user
    @do_logout = true
  end
end
