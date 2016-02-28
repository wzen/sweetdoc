require 'base64'

class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # action
  before_action :set_locale
  before_action :init_const
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :touch_if_guest
  after_action :store_location
  helper_method :mobile_access?

  def init_const
    # Constantの設定
    gon.const  = const_values(Const, {})
    gon.serverenv  = ENV
    gon.locale = I18n.locale
    gon.user_logined = user_signed_in?
    gon.is_mobile_access = mobile_access?
  end

  def const_values(const_class, obj)
    if const_class.is_a?(Class)
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
  end

  def current_or_guest_user
    if @_current_user
      return @_current_user
    else
      if session[:user_id]
        u = User.find_by(:id => session[:user_id])
        if u.present?
          @_current_user  = u
        else
          # セッション削除
          destroy_current_user
          @_current_user = guest_user
        end
      else
        @_current_user = guest_user
      end
      return @_current_user
    end
  end

  # 現在のセッションと関連づく guest_user オブジェクトを探す
  def guest_user(with_retry = true)
    if session[:guest_user_id].present? && session[:guest_expire_date] < Time.now
      # 期限が切れている場合、セッション削除してゲスト再生成
      destroy_current_user
    end
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
    session[:guest_expire_date] = Time.now + ENV['GUEST_SESSION_EXPIRE_MINUTES'].to_i.minutes
    return guest
  end

  def set_current_user(user)
    @_current_user = user
    session[:user_id] = user.id
    unless user.guest && session[:guest_user_id].present?
      # Guestキャッシュ削除
      guest_user(with_retry = false).try(:destroy)
      session[:guest_user_id] = nil
    end
  end

  def destroy_current_user
    @_current_user = nil
    session[:user_id] = nil
    session[:guest_user_id] = nil
    reset_session
  end

  def store_location
    return if do_through

    return unless request.get?
    if request.path !~ /^\/user.*/ &&
        request.path !~ /^\/my_page.*/ &&
        !request.xhr? # don't store ajax calls
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
    return if do_through

    locale = params[:locale] || locale_from_accept_language || locale_from_ip
    if locale.blank?
      locale = 'ja'
    end
    I18n.locale = (I18n::available_locales.include? locale.to_sym) ? locale.to_sym : I18n.default_locale
  end

  # ActiveRecord Like エスケープ
  def escape_like(string)
    string.gsub(/[\\%_]/){|m| "\\#{m}"}
  end

  # 未ログインの場合はリダイレクト
  def redirect_if_not_login
    return if do_through

    if !user_signed_in?
      # ゲストの場合リダイレクト
      redirect_to 'gallery/grid'
    end
  end

  def mobile_access?
    ua = request.env["HTTP_USER_AGENT"]
    return ua.include?('Mobile') || ua.include?('Android')
  end

  protected
  def configure_permitted_parameters
    return if do_through

    #strong parametersを設定し、nameを許可
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:name, :email, :password, :password_confirmation) }
  end

  def locale_from_accept_language
    if request.env['HTTP_ACCEPT_LANGUAGE'].present?
      request.env['HTTP_ACCEPT_LANGUAGE'].scan(/^[a-z]{2}/).first
    end
    nil
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

  def touch_if_guest
    return if do_through

    if !user_signed_in? && current_or_guest_user.guest
      # ゲストの場合Userテーブルの更新日を更新
      u = User.find_by(id: current_or_guest_user.id)
      if u.present?
        u.touch
        u.save
      end
    end
  end

  private
  def do_through
    # 以下のリクエストの場合は処理しない
    pass_list = [
        {controller: 'gallery', action: 'thumbnail'}
    ]
    pass_list.each do |p|
      if controller_name == p[:controller] && action_name == p[:action]
        return true
      end
    end
    return false
  end

end
