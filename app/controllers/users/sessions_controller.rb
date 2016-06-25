class Users::SessionsController < Devise::SessionsController
  def new
    super
  end

  def create
    if current_user.present?
      # login
      set_current_user(current_user)
      @do_login = true
    end
    super
  end

  def destroy
    # logout
    destroy_current_user
    @do_logout = true
    super
  end
end
