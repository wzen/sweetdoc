require 'coding/coding'

class CodingController < ApplicationController

  def save_all
    user_id = current_or_guest_user.id
    codes = params.fetch(Const::Coding::Key::CODES, {}).values
    tree_data = params.fetch(Const::Coding::Key::TREE_DATA, {}).values
    @result_success, @message = Coding.save_all(user_id, codes, tree_data)
  end

  def update_code
    user_id = current_or_guest_user.id
    codes = params.fetch(Const::Coding::Key::CODES, {}).values
    @result_success, @message = Coding.update_code(user_id, codes)
  end

  def save_tree
    user_id = current_or_guest_user.id
    tree_data = params.fetch(Const::Coding::Key::TREE_DATA, {}).values
    @result_success, @message = Coding.save_tree(user_id, tree_data)
  end

  def save_state
    user_id = current_or_guest_user.id
    tree_data = params.fetch(Const::Coding::Key::TREE_DATA, {}).values
    codes = params.fetch(Const::Coding::Key::CODES, {}).values
    @result_success, @message = Coding.save_state(user_id, tree_data, codes)
  end

  def add_new_file
    user_id = current_or_guest_user.id
    node_path = params.require(Const::Coding::Key::NODE_PATH)
    lang = params.require(Const::Coding::Key::LANG)
    draw_type = params.require(Const::Coding::Key::DRAW_TYPE).to_i
    @result_success, @message, @add_user_coding_id, @code = Coding.add_new_file(user_id, node_path, lang, draw_type)
  end

  def add_new_folder
    user_id = current_or_guest_user.id
    node_path = params.require(Const::Coding::Key::NODE_PATH)
    @result_success, @message = Coding.add_new_folder(user_id, node_path)
  end

  def delete_node
    node_path = params.require(Const::Coding::Key::NODE_PATH)
    @result_success, @message = Coding.delete_node(user_id, node_path)
  end

  def load_code
    user_id = current_or_guest_user.id
    user_coding_id = params.fetch(Const::Coding::Key::USER_CODING_ID, nil)
    @result_success, @load_data = Coding.load_code(user_id, user_coding_id)
  end

  def load_tree
    user_id = current_or_guest_user.id
    @result_success, @load_tree = Coding.load_tree(user_id)
  end

  def upload
    user_id = current_or_guest_user.id
  end

  def item
    # Constantの設定
    init_const

    user_id = current_or_guest_user.id
    @load_user_coding = Coding.load_opened_code(user_id)
    @load_tree_html, @load_user_codings, @code_state = Coding.load_coding_item_data(user_id)
    @user = current_or_guest_user
  end

  def item_preview
    user_id = current_or_guest_user.id
    @code = params.require(Const::Coding::Key::CODE)
    @lang_type = params.require(Const::Coding::Key::LANG)
  end

end
