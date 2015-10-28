require 'coding/gallery_coding'
require 'coding/user_coding'
require 'coding/user_gallery_coding_map'

class Coding
  def self.save_all(user_id, codes, tree_states)
    begin
      ActiveRecord::Base.transaction do
        _save_code(user_id, codes)
        _replace_all_tree(user_id, tree_states)
      end
      return I18n.t('message.database.item_state.save.success')
    rescue => e
      # 失敗
      return I18n.t('message.database.item_state.save.error')
    end
  end

  def self.save_code(user_id, codes)
    begin
      ActiveRecord::Base.transaction do
        _save_code(user_id, codes)
      end
      return I18n.t('message.database.item_state.save.success')
    rescue => e
      # 失敗
      return I18n.t('message.database.item_state.save.error')
    end
  end

  def self.add_new_file(user_id, parent_node_path, lang_type)
    begin
      user_coding_id = nil
      code = {}
      ActiveRecord::Base.transaction do
        code[Const::Coding::Key::NAME] = 'untitled'
        code[Const::Coding::Key::LANG] = lang_type
        if lang_type == Const::Coding::Lang::JAVASCRIPT
          file_path = File.join(Rails.root, '/public/code_template/item/javascript.js')
        else
          file_path = File.join(Rails.root, '/public/code_template/item/coffeescript.coffee')
        end
        code[Const::Coding::Key::CODE] = ''
        File.open(file_path,'r') do |file|
          file.each do |read_line|
            code[Const::Coding::Key::CODE] += read_line
          end
        end
        _back_all_codes(user_id)
        save_ids = _save_code(user_id, [code])
        user_coding_id = save_ids.first

        tree_state = {}
        tree_state[Const::Coding::Key::NODE_PATH] = parent_node_path + "/#{Const::Coding::DEFAULT_FILENAME}"
        tree_state[Const::Coding::Key::USER_CODING_ID] = user_coding_id
        tree_state[Const::Coding::Key::IS_OPENED] = false
        _save_tree(user_id, tree_state)
      end
      return I18n.t('message.database.item_state.save.success'), user_coding_id, code
    rescue => e
      # 失敗
      return I18n.t('message.database.item_state.save.error'), nil, nil
    end
  end

  def self.add_new_folder(user_id, parent_node_path)
    begin
      ActiveRecord::Base.transaction do
        tree_state = {}
        tree_state[Const::Coding::Key::NODE_PATH] = parent_node_path + "/#{Const::Coding::DEFAULT_FILENAME}"
        tree_state[Const::Coding::Key::USER_CODING_ID] = nil
        tree_state[Const::Coding::Key::IS_OPENED] = false
        _save_tree(user_id, tree_state)
      end
      return I18n.t('message.database.item_state.save.success')
    rescue => e
      # 失敗
      return I18n.t('message.database.item_state.save.error')
    end
  end

  def self.save_tree(user_id, tree_states)
    begin
      ActiveRecord::Base.transaction do
        _replace_all_tree(user_id, tree_states)
      end
      return I18n.t('message.database.item_state.save.success')
    rescue => e
      # 失敗
      return I18n.t('message.database.item_state.save.error')
    end
  end

  def self.load_code(user_id, user_coding_id = nil)
    begin
      ActiveRecord::Base.transaction do
        if user_coding_id
          uc = UserCoding.where(id: user_coding_id, user_id: user_id, del_flg: false)
        else
          uc = UserCoding.where(user_id: user_id, del_flg: false)
        end
        return uc
      end
    rescue => e
      # 失敗
      return []
    end
  end

  def self.load_opened_code(user_id)
    begin
      ActiveRecord::Base.transaction do
        return UserCoding.where(user_id: user_id, is_opened: true, del_flg: false)
      end
    rescue => e
      # 失敗
      return []
    end
  end

  def self.load_tree(user_id)
    begin
      ActiveRecord::Base.transaction do
        uc = UserCodingTree.where(user_id: user_id, del_flg: false)
        return _mk_path_treedata(uc)
      end
    rescue => e
      # 失敗
      return []
    end
  end

  def self.load_tree_html(user_id)
    data = load_tree(user_id)
    return _mk_tree_path_html(data)
  end

  def self.upload(user_id, user_coding_id)
    begin
      ActiveRecord::Base.transaction do
        uc = UserCoding.find_by(id: user_coding_id, user_id: user_id, del_flg: false)
        if uc != nil
          ugcm = UserGalleryCodingMap.find_by(user_id: user_id, del_flg: false)
        else
          # データ無し
          return I18n.t('message.database.item_state.save.error')
        end
      end
    rescue => e
      # 失敗
      return I18n.t('message.database.item_state.save.error')
    end
  end

  def self._mk_path_treedata(user_coding_trees)
    ret = {}
    user_coding_trees.each do |user_coding_tree|
      node_path = user_coding_tree['node_path'].split('/')
      obj = ret
      node_path.each_with_index do |n, idx|
        unless obj[n]
          obj[n] = {}
        end

        if idx == node_path.length - 1
          obj[n] = user_coding_tree
        else
          obj = obj[n]
        end
      end
    end
    return ret
  end

  def self._mk_tree_path_html(node)
    ret = ''
    node.each do |k, v|
      if v.is_a? Hash
        child = _mk_tree_path_html(v)
        ret += "<li class='dir'>#{k}<ul>#{child}</ul></li>"
      else
        input = ''
        user_coding_val = ['id', 'name', 'lang_type']
        user_coding_val.each do |val|
          input += "<input type='hidden' class='#{val}' value='#{v[val]}' />"
        end
        ret += "<li class='tip'>#{k}#{input}</li>"
      end
    end
    return ret
  end

  def self._save_code(user_id, codes)
    ret = []
    codes.each do |c|
      name = c[Const::Coding::Key::NAME]
      lang_type = c[Const::Coding::Key::LANG]
      code = c[Const::Coding::Key::CODE]

      uc = UserCoding.find_by(user_id: user_id, name: name, lang_type: lang_type, del_flg: false)
      if uc == nil
        uc = UserCoding.new({
                                user_id: user_id,
                                name: name,
                                lang_type: lang_type,
                                code: code
                            })
      else
        uc.code = code
      end
      uc.save!
      ret << uc.id
    end
    return ret
  end

  def self._back_all_codes(user_id)
    # 全てのコードを背面にする
    UserCoding.where(user_id).update_all(is_front: false)
  end

  def self._replace_all_tree(user_id, tree_states)
    ret = []
    # ツリーを論理削除
    UserCodingTree.where(user_id: user_id, del_flg: false).update_all(del_flg: true)
    # ツリー状態を保存
    tree_states.each do |tree_state|
      node_path = tree_state[Const::Coding::Key::NODE_PATH]
      user_coding_id = tree_state[Const::Coding::Key::USER_CODING_ID]
      is_opened =  tree_state[Const::Coding::Key::IS_OPENED]
      uct = UserCodingTree.new({
                                   user_id: user_id,
                                   node_path: node_path,
                                   user_coding_id: user_coding_id,
                                   is_opened: is_opened
                               })
      uct.save!
      ret << uct.id
    end
    return ret
  end

  def self._save_tree(user_id, tree_state)
    node_path = tree_state[Const::Coding::Key::NODE_PATH]
    user_coding_id = tree_state[Const::Coding::Key::USER_CODING_ID]
    is_opened =  tree_state[Const::Coding::Key::IS_OPENED]
    uct = UserCodingTree.find_by(user_id: user_id, node_path: node_path, del_flg: false)
    if uct == nil
      uct = UserCodingTree.new({
                                   user_id: user_id,
                                   node_path: node_path,
                                   user_coding_id: user_coding_id,
                                   is_opened: is_opened
                               })
    else
      uct.user_coding_id = user_coding_id
      uct.is_opened = is_opened
    end
    uct.save!

    return uct.id
  end

  private_class_method :_mk_path_treedata, :_mk_tree_path_html, :_save_code, :_replace_all_tree

end