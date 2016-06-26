class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  include UserConcern::Utils

  def facebook
    # You need to implement the method below in your model (e.g. app/models/user.rb)
    @user = find_for_facebook_oauth(request.env["omniauth.auth"], current_user)

    if @user.persisted?
      set_current_user(@user)
      @do_login = true
      set_flash_message(:notice, :success, :kind => "Facebook") if is_navigational_format?
      sign_in_and_redirect @user, :event => :authentication
    else
      session["devise.facebook_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end

  def twitter
    # You need to implement the method below in your model
    @user = find_for_twitter_oauth(request.env["omniauth.auth"], current_user)

    if @user.persisted?
      set_current_user(@user)
      @do_login = true
      set_flash_message(:notice, :success, :kind => "Twitter") if is_navigational_format?
      sign_in_and_redirect @user, :event => :authentication
    else
      session["devise.twitter_data"] = request.env["omniauth.auth"].except("extra")
      redirect_to new_user_registration_url
    end
  end

  def google_oauth2
    @user = find_for_google_oauth2(request.env["omniauth.auth"])

    if @user.persisted?
      set_current_user(@user)
      @do_login = true
      set_flash_message(:notice, :success, :kind => "Google") if is_navigational_format?
      sign_in_and_redirect @user, :event => :authentication
    else
      session["devise.google_data"] = request.env["omniauth.auth"].except("extra")
      redirect_to new_user_registration_url
    end
  end
end