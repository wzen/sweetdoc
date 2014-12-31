require 'const'

class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # Locale
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
  def set_locale
    # TODO: サブドメインから引っ張るように修正
    I18n.locale = params[:locale] || I18n.default_locale
  end
end
