require 'coding/gallery_coding'
require 'coding/user_coding'
require 'coding/user_gallery_coding_map'
require 'coding/user_coding_tree'

class Coding
  def self.save_all(user_id, codes, tree_data)
    begin
      ActiveRecord::Base.transaction do
        _save_code(user_id, codes)
        _replace_all_tree(user_id, tree_data)
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

  def self.save_state(user_id, tree_data, codes)
    # ツリー&エディタ状態をMemcachedに保存
    tree_state = get_tree_state(user_id)
    tree_data.each do |td|
      if tree_state[td[Const::Coding::Key::NODE_PATH]].nil?
        tree_state[td[Const::Coding::Key::NODE_PATH]] = {}
      end
      tree_state[td[Const::Coding::Key::NODE_PATH]][Const::Coding::Key::IS_OPENED] = td[Const::Coding::Key::IS_OPENED]
    end
    Rails.cache.write(Const::Coding::CacheKey::TREE_STATE_KEY.gsub('@user_id', user_id.to_s), tree_state, expires_in: 6.months)

    code_state = get_code_state(user_id)
    code_state.each do |k, v|
      if code_state[k].nil?
        code_state[k] = {}
      end
      code_state[k][Const::Coding::Key::IS_OPENED] = false
      code_state[k][Const::Coding::Key::IS_ACTIVE] = false
    end
    codes.each do |co|
      user_coding_id = co[Const::Coding::Key::USER_CODING_ID]
      if code_state[user_coding_id].nil?
        code_state[user_coding_id] = {}
      end
      code_state[user_coding_id][Const::Coding::Key::IS_OPENED] = co[Const::Coding::Key::IS_OPENED]
      code_state[user_coding_id][Const::Coding::Key::IS_ACTIVE] = co[Const::Coding::Key::IS_ACTIVE]
    end
    Rails.cache.write(Const::Coding::CacheKey::CODE_STATE_KEY.gsub('@user_id', user_id.to_s), code_state, expires_in: 6.months)
    return I18n.t('message.database.item_state.save.success')
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

        path_array = parent_node_path.split('/') << Const::Coding::DEFAULT_FILENAME
        node_path = []
        path_array.each do |path|
          tree_data = {}
          node_path.push(path)
          tree_data[Const::Coding::Key::NODE_PATH] = node_path.join('/')
          tree_data[Const::Coding::Key::USER_CODING_ID] = user_coding_id
          _save_tree(user_id, tree_data)
        end
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
        tree_data = {}
        tree_data[Const::Coding::Key::NODE_PATH] = parent_node_path + "/#{Const::Coding::DEFAULT_FILENAME}"
        tree_data[Const::Coding::Key::USER_CODING_ID] = nil
        _save_tree(user_id, tree_data)
      end
      return I18n.t('message.database.item_state.save.success')
    rescue => e
      # 失敗
      return I18n.t('message.database.item_state.save.error')
    end
  end

  def self.save_tree(user_id, tree_data)
    begin
      ActiveRecord::Base.transaction do
        _replace_all_tree(user_id, tree_data)
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
        uc = UserCoding.where(user_id: user_id, del_flg: false)
        code_state = get_code_state(user_id)
        return uc.select do |s|
          code_state[s['id']] && code_state[s['id']][Const::Coding::Key::IS_OPENED]
        end
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

  def self.load_coding_item_data(user_id)
    data = load_tree(user_id)
    tree_state = get_tree_state(user_id)
    code_state = get_code_state(user_id)
    return _mk_tree_path_html(data, tree_state, code_state), code_state
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

        if idx < node_path.length - 1
          obj = obj[n]
        else
          obj['tree_value'] = user_coding_tree
        end
      end
    end
    return ret
  end

  def self._mk_tree_path_html(node, tree_state, code_state)
    ret = ''
    node.each do |k, v|
      if k == 'tree_value'
        next
      end

      user_coding_tree = node['tree_value']
      if v && !v.empty?
        child = _mk_tree_path_html(v, tree_state, code_state)
        opened = ''
        if tree_state &&
            tree_state[user_coding_tree[Const::Coding::Key::NODE_PATH]] &&
            tree_state[user_coding_tree[Const::Coding::Key::NODE_PATH]][Const::Coding::Key::IS_OPENED] &&
            tree_state[user_coding_tree[Const::Coding::Key::NODE_PATH]][Const::Coding::Key::IS_OPENED] == 'true'
          opened = 'jstree-open'
        end
        ret += "<li class='dir #{opened}'>#{k}<ul>#{child}</ul></li>"
      else
        input = ''
        user_coding_tree_val = ['user_coding_id']
        user_coding_tree_val.each do |val|
          input += "<input type='hidden' class='#{val}' value='#{user_coding_tree[val]}' />"
        end
        selected = ''
        if code_state[user_coding_tree['user_coding_id']] && code_state[user_coding_tree['user_coding_id']][Const::Coding::Key::IS_ACTIVE]
          selected = ',"selected":"true"'
        end
        ret += "<li class='tip' data-jstree='{\"icon\":\"jstree-file\"#{selected}}'>#{k}#{input}</li>"
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
    # FIXME: memcachedにする
    uc = UserCoding.where(user_id)
    code_state = get_code_state(user_id)
    uc.each{|u| }
  end

  def self._replace_all_tree(user_id, tree_data)
    ret = []
    # ツリーを論理削除
    UserCodingTree.where(user_id: user_id, del_flg: false).update_all(del_flg: true)
    # ツリー状態を保存
    tree_data.each do |td|
      node_path = td[Const::Coding::Key::NODE_PATH]
      user_coding_id = td[Const::Coding::Key::USER_CODING_ID]
      uct = UserCodingTree.new({
                                   user_id: user_id,
                                   node_path: node_path,
                                   user_coding_id: user_coding_id
                               })
      uct.save!
      ret << uct.id
    end
    return ret
  end

  def self._save_tree(user_id, tree_data)
    node_path = tree_data[Const::Coding::Key::NODE_PATH]
    user_coding_id = tree_data[Const::Coding::Key::USER_CODING_ID]
    uct = UserCodingTree.find_by(user_id: user_id, node_path: node_path, del_flg: false)
    if uct == nil
      uct = UserCodingTree.new({
                                   user_id: user_id,
                                   node_path: node_path,
                                   user_coding_id: user_coding_id
                               })
    else
      uct.user_coding_id = user_coding_id
    end
    uct.save!

    return uct.id
  end

  def self.get_tree_state(user_id)
    r = Rails.cache.read(Const::Coding::CacheKey::TREE_STATE_KEY.gsub('@user_id', user_id.to_s))
    return r ? r : {}
  end
  def self.get_code_state(user_id)
    r = Rails.cache.read(Const::Coding::CacheKey::CODE_STATE_KEY.gsub('@user_id', user_id.to_s))
    return r ? r : {}
  end

  private_class_method :_mk_path_treedata, :_mk_tree_path_html, :_save_code, :_replace_all_tree

end