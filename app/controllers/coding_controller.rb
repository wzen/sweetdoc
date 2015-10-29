require 'coding/coding'

class CodingController < ApplicationController

  def save_all
    user_id = current_or_guest_user.id
    codes = params.require(Const::Coding::Key::CODES).values
    tree_data = params.require(Const::Coding::Key::TREE_DATA).values
    @message = Coding.save_all(user_id, codes, tree_data)
  end

  def save_code
    user_id = current_or_guest_user.id
    codes = params.require(Const::Coding::Key::CODES).values
    @message = Coding.save_code(user_id, codes)
  end

  def save_tree
    user_id = current_or_guest_user.id
    tree_data = params.require(Const::Coding::Key::TREE_DATA).values
    @message = Coding.save_tree(user_id, tree_data)
  end

  def save_state
    user_id = current_or_guest_user.id
    tree_data = params.require(Const::Coding::Key::TREE_DATA).values
    codes = params.require(Const::Coding::Key::CODES).values
    @message = Coding.save_state(user_id, tree_data, codes)
  end

  def add_new_file
    user_id = current_or_guest_user.id
    parent_node_path = params.require(Const::Coding::Key::PARENT_NODE_PATH)
    lang = params.require(Const::Coding::Key::LANG)
    @message, @add_user_coding_id, @code = Coding.add_new_file(user_id, parent_node_path, lang)
  end

  def add_new_folder
    user_id = current_or_guest_user.id
    parent_node_path = params.require(Const::Coding::Key::PARENT_NODE_PATH)
    @message = Coding.add_new_folder(user_id, parent_node_path)
  end

  def load_code
    user_id = current_or_guest_user.id
    user_coding_id = params.require(Const::Coding::Key::USER_CODING_ID)
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
    @load_user_coding = Coding.load_opened_code(user_id)
    @load_tree_html, @code_state = Coding.load_coding_item_data(user_id)
    @user = current_or_guest_user
  end

end
