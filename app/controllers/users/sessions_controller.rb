class Users::SessionsController < Devise::SessionsController
  def new
    super
  end

  def create
    # login
    set_current_user(current_user)
    @do_login = true
    super
  end

  def destroy
    # logout
    destroy_current_user
    @do_logout = true
    super
  end
end
