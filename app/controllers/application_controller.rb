require 'base64'

class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # Locale
  before_filter :set_locale
  before_filter :init_const
  before_filter :configure_permitted_parameters, if: :devise_controller?
  after_filter :store_location

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

  def current_or_guest_user
    if @_current_user
      if session[:guest_user_id] && session[:guest_user_id] != @_current_user.id
        # Guestキャッシュ削除
        guest_user(with_retry = false).try(:destroy)
        session[:guest_user_id] = nil
       end
      return @_current_user
    else
      if session[:user_id]
        @_current_user ||= User.find(session[:user_id])
      else
        @_current_user = guest_user
      end
      return @_current_user
    end
  end

  # 現在のセッションと関連づく guest_user オブジェクトを探す
  def guest_user(with_retry = true)
    @cached_guest_user ||= User.find(session[:guest_user_id] ||= create_guest_user.id)
  rescue ActiveRecord::RecordNotFound # if session[:guest_user_id] invalid
    session[:guest_user_id] = nil
    guest_user if with_retry
  end

  def guest_user?
    @_current_user && @_current_user.guest?
  end

  # ログインしていない、もしくは、Guestユーザーの場合、ルートにリダイレクトする
  def authenticate_no_user_or_guest!
    redirect_to root_url if @_current_user.nil? || guest_user?
  end

  # Guestユーザーを作成する
  def create_guest_user
    guest = User.new_guest
    guest.save!(:validate => false)
    session[:guest_user_id] = guest.id
    return guest
  end

  def set_current_user(user)
    @_current_user = user
    session[:user_id] = user.id
  end

  def destroy_current_user
    @_current_user = nil
    session[:user_id] = nil
  end

  def store_location
    return unless request.get?
    if (request.path != "/user/sign_in" &&
        request.path != "/user/sign_in?" &&
        request.path != "/user/sign_up" &&
        request.path != "/user/password/new" &&
        request.path != "/user/password/edit" &&
        request.path != "/user/confirmation" &&
        request.path != "/user/sign_out" &&
        !request.xhr?) # don't store ajax calls
      session[:previous_url] = request.fullpath
    end
  end

  #ログイン後のリダイレクトをログイン前のページにする
  def after_sign_in_path_for(resource)
    session[:previous_url] || root_path
  end

  #ログアウト後のリダイレクトをログアウト前のページにする
  def after_sign_out_path_for(resource)
    session[:previous_url] || root_path
  end

  def set_locale
    #I18n.locale = params[:locale] || I18n.default_locale
    locale = params[:locale] || locale_from_accept_language || locale_from_ip
    I18n.locale = (I18n::available_locales.include? locale.to_sym) ? locale.to_sym : I18n.default_locale
  end

  # ActiveRecord Like エスケープ
  def escape_like(string)
    string.gsub(/[\\%_]/){|m| "\\#{m}"}
  end

  protected
  def configure_permitted_parameters
    #strong parametersを設定し、nameを許可
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:name, :email, :password, :password_confirmation) }
  end

  def locale_from_accept_language
    request.env['HTTP_ACCEPT_LANGUAGE'].scan(/^[a-z]{2}/).first
  end

  def locale_from_ip
    locale_from_ip = nil

    geoip ||= GeoIP.new(Rails.root.join( "db/GeoIP.dat" ))
    country = geoip.country(request.remote_ip)
    code = country.country_code2.downcase

    if code == "jp"
      locale_from_ip = "ja"
    elsif code.present? && code != "--"
      locale_from_ip = "en"
    end

    locale_from_ip
  end

end
