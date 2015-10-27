require 'coding/coding'

class CodingController < ApplicationController

  def save
    user_id = current_or_guest_user.id
    name = params[Const::Coding::Key::NAME]
    lang = params[Const::Coding::Key::LANG]
    code = params[Const::Coding::Key::CODE]
    tree_state = params[Const::Coding::Key::TREE_STATE]
    @message = Coding.save(user_id, name, lang, code, tree_state)
  end

  def load_code
    user_id = current_or_guest_user.id
    user_coding_id = params[Const::Coding::Key::USER_CODING_ID]
    @load_data = Coding.load_code(user_id, user_coding_id)
  end

  def load_tree
    user_id = current_or_guest_user.id
    @load_tree = Coding.load_tree(user_id)
  end

  def upload
    user_id = current_or_guest_user.id
  end

  def item
    # Constantの設定
    init_const

    user_id = current_or_guest_user.id
    @load_editor_data = Coding.load_opened_code(user_id)
    @load_tree_data = Coding.load_tree_html(user_id)
    @user = current_or_guest_user
  end

end
