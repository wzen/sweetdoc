require 'const'

class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # Locale
  before_action :login
  before_filter :set_locale

  def init_const
    # Constantの設定
    gon.const  = const_values(Const, {})
  end

  def const_values(const_class, obj)
    const_class.constants.each do |c|
      v = const_class.const_get(c)
      if v.is_a? Class
        obj[c] = const_values(v, {})
      else
        obj[c] = v
      end
    end
    return obj
  end

  private
  def login
    if session[:user_id].blank?
      user = User.create(name: 'temp', user_auth_id: 3)
      session[:user_id] = user.id
    end
  end

  def current_user
    @_current_user ||= User.find_by(id: session[:user_id])
    if @_current_user == nil
      destroy_current_user
      login
    end
    @_current_user ||= User.find_by(id: session[:user_id])
  end

  def destroy_current_user
    @_current_user = session[:user_id] = nil
    redirect_to root_url
  end

  def set_locale
    # TODO: サブドメインから引っ張るように修正
    I18n.locale = params[:locale] || I18n.default_locale
  end




end
