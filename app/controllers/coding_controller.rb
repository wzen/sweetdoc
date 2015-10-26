require 'coding/coding'

class CodingController < ApplicationController

  def save_code
    user_id = current_or_guest_user.id
    name = params[Const::Coding::Key::NAME]
    lang = params[Const::Coding::Key::LANG]
    code = params[Const::Coding::Key::CODE]
    @message = Coding.save_code(user_id, name, lang, code)
  end

  def load_code
    user_id = current_or_guest_user.id
    @load_data = Coding.load_code(user_id)
  end


  def upload
    user_id = current_or_guest_user.id
  end

  def item
    # Constantの設定
    init_const

    load_code
    @user = current_or_guest_user
  end

end
