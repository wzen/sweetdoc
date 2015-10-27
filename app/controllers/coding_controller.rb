require 'coding/coding'

class CodingController < ApplicationController

  def save_all
    user_id = current_or_guest_user.id
    codes = params[Const::Coding::Key::CODES]
    tree_state = params[Const::Coding::Key::TREE_STATE]
    @message = Coding.save_all(user_id, codes, tree_state)
  end

  def save_code
    user_id = current_or_guest_user.id
    codes = params[Const::Coding::Key::CODES]
    @message = Coding.save_code(user_id, codes)
  end

  def save_tree
    user_id = current_or_guest_user.id
    tree_state = params[Const::Coding::Key::TREE_STATE]
    @message = Coding.save_tree(user_id, tree_state)
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
