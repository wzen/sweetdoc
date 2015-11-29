require 'coding/item_gallery'
require 'coding/user_coding'
require 'coding/user_item_gallery_map'
require 'coding/user_coding_tree'

class Coding

  USER_CODE_PATH = '/user_code/'
  COFFEESCRIPT_SUFFIX = '__cbase'

  def self.save_all(user_id, codes, tree_data)
    begin
      ActiveRecord::Base.transaction do
        _update_code(user_id, codes)
        _replace_all_tree(user_id, tree_data)
      end
      return true, I18n.t('message.database.item_state.save.success')
    rescue => e
      # 失敗
      return false, I18n.t('message.database.item_state.save.error')
    end
  end

  def self.update_code(user_id, codes)
    begin
      ActiveRecord::Base.transaction do
        _update_code(user_id, codes)
      end
      return true, I18n.t('message.database.item_state.save.success')
    rescue => e
      # 失敗
      return false, I18n.t('message.database.item_state.save.error')
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
    Rails.cache.write(Const::Coding::CacheKey::TREE_STATE_KEY.gsub('@user_id', user_id.to_s), tree_state, expires_in: 1.month)

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
    Rails.cache.write(Const::Coding::CacheKey::CODE_STATE_KEY.gsub('@user_id', user_id.to_s), code_state, expires_in: 1.month)
    return true, I18n.t('message.database.item_state.save.success')
  end

  def self.add_new_file(user_id, node_path, lang_type, draw_type)
    begin
      user_coding_id = nil
      code = {}
      ActiveRecord::Base.transaction do
        code[Const::Coding::Key::LANG] = lang_type
        code[Const::Coding::Key::DRAW_TYPE] = draw_type
        draw_type_surfix = ''
        if draw_type == Const::ItemDrawType::CANVAS
          draw_type_surfix = 'canvas'
        elsif draw_type == Const::ItemDrawType::CSS
          draw_type_surfix = 'css'
        end
        if lang_type == Const::Coding::Lang::JAVASCRIPT
          file_path = File.join(Rails.root, "/public/code_template/item/#{I18n.locale}/javascript_#{draw_type_surfix}.js")
        else
          file_path = File.join(Rails.root, "/public/code_template/item/#{I18n.locale}/coffeescript_#{draw_type_surfix}.coffee")
        end
        code[Const::Coding::Key::CODE] = ''
        File.open(file_path,'r') do |file|
          file.each do |read_line|
            code[Const::Coding::Key::CODE] += read_line
          end
        end
        _back_all_codes(user_id)
        user_coding_id = _add_code(user_id, code)

        path_array = node_path.split('/')
        np = []
        path_array.each_with_index do |path, idx|
          tree_data = {}
          np.push(path)
          tree_data[Const::Coding::Key::NODE_PATH] = np.join('/')
          if idx == path_array.length - 1
            tree_data[Const::Coding::Key::USER_CODING_ID] = user_coding_id
          else
            tree_data[Const::Coding::Key::USER_CODING_ID] = nil
          end
          _save_tree(user_id, tree_data)
        end
      end
      return true, I18n.t('message.database.item_state.save.success'), user_coding_id, code
    rescue => e
      # 失敗
      return false, I18n.t('message.database.item_state.save.error'), nil, nil
    end
  end

  def self.add_new_folder(user_id, node_path)
    begin
      ActiveRecord::Base.transaction do
        tree_data = {}
        tree_data[Const::Coding::Key::NODE_PATH] = node_path
        tree_data[Const::Coding::Key::USER_CODING_ID] = nil
        _save_tree(user_id, tree_data)
      end
      return true, I18n.t('message.database.item_state.save.success')
    rescue => e
      # 失敗
      return false, I18n.t('message.database.item_state.save.error')
    end
  end

  def self.delete_node(user_id, node_path)
    begin
      ActiveRecord::Base.transaction do
        uct = UserCodingTree.where('user_id = ? AND node_path LIKE ? AND del_flg = 0', user_id, "%#{escape_like(node_path)}%")
        uct.each do |u|
          if u['user_coding_id']
            UserCoding.update_all({del_flg: true}, {id: u['user_coding_id']})
          end
        end
        uct.update_all(del_flg: true)
      end
      return true, I18n.t('message.database.item_state.save.success')
    rescue => e
      # 失敗
      return false, I18n.t('message.database.item_state.save.error')
    end
  end

  def self.save_tree(user_id, tree_data)
    begin
      ActiveRecord::Base.transaction do
        _replace_all_tree(user_id, tree_data)
      end
      return true, I18n.t('message.database.item_state.save.success')
    rescue => e
      # 失敗
      return false, I18n.t('message.database.item_state.save.error')
    end
  end

  def self.load_code(user_id, user_coding_id = nil)
    begin
      ActiveRecord::Base.transaction do
        u_sql = ''
        if user_coding_id
          u_sql = "AND uc.id = #{user_coding_id}"
        end
        sql =<<-"SQL"
          SELECT uc.code_filename as code_filename, uct.node_path as node_path, uc.lang_type as lang_type, uc.id as id, u.access_token as user_access_token
          FROM user_codings uc
          RIGHT JOIN user_coding_trees uct ON uc.user_id = uct.user_id AND uc.del_flg = 0 AND uct.del_flg = 0
          INNER JOIN users u ON uc.user_id = u.id
          AND uc.id = uct.user_coding_id
          AND u.del_flg = 0
          WHERE u.id = #{user_id} #{u_sql}
        SQL
        ret_sql = ActiveRecord::Base.connection.select_all(sql)
        ret = ret_sql.to_hash

        ret = ret.map do |m|
          user_access_token = m['user_access_token']
          nodes = m['node_path'].split('/')
          m['name'] = nodes[nodes.length - 1]
          filepath = _code_filepath(user_access_token, m['code_filename'])
          if m['lang_type'] == Const::Coding::Lang::COFFEESCRIPT
            filepath += COFFEESCRIPT_SUFFIX
          end
          code = ''
          File.open(filepath, 'r') do |f|
            f.each do |read_line|
              code += read_line
            end
          end
          m['code'] = code
          m
        end

        return true, ret
      end
    rescue => e
      # 失敗
      return true, []
    end
  end

  def self.load_opened_code(user_id)
    begin
      ActiveRecord::Base.transaction do
        sql =<<-"SQL"
          SELECT uc.code_filename as code_filename, uct.node_path as node_path, uc.lang_type as lang_type, uc.id as id, u.access_token as user_access_token
          FROM user_codings uc
          RIGHT JOIN user_coding_trees uct ON uc.user_id = uct.user_id AND uc.del_flg = 0 AND uct.del_flg = 0
          INNER JOIN users u ON uc.user_id = u.id
          AND uc.id = uct.user_coding_id
          AND u.del_flg = 0
          WHERE u.id = #{user_id}
        SQL
        ret_sql = ActiveRecord::Base.connection.select_all(sql)
        uc = ret_sql.to_hash
        code_state = get_code_state(user_id)
        uc = uc.select do |s|
          code_state[s['id'].to_s] && code_state[s['id'].to_s][Const::Coding::Key::IS_OPENED]
        end
        ret = uc.map do |m|
          user_access_token = m['user_access_token']
          nodes = m['node_path'].split('/')
          m['name'] = nodes[nodes.length - 1]
          filepath = _code_filepath(user_access_token, m['code_filename'])
          if m['lang_type'] == Const::Coding::Lang::COFFEESCRIPT
            filepath += COFFEESCRIPT_SUFFIX
          end
          code = ''
          File.open(filepath, 'r') do |f|
            f.each do |read_line|
              code += read_line
            end
          end
          m['code'] = code
          m
        end
        return ret
      end
    rescue => e
      # 失敗
      return []
    end
  end

  def self.code_filepath(user_id, user_coding_id)
    begin
      ActiveRecord::Base.transaction do
        sql =<<-"SQL"
          SELECT uc.code_filename as code_filename, uc.lang_type as lang_type, u.access_token as user_access_token
          FROM user_codings uc
          INNER JOIN users u ON uc.user_id = u.id
          WHERE u.id = #{user_id}
          AND u.del_flg = 0
          AND uc.id = #{user_coding_id}
          AND uc.del_flg = 0
        SQL
        ret_sql = ActiveRecord::Base.connection.select_all(sql)
        r = ret_sql.to_hash
        if r.count > 0
          return _code_urlpath(r.first['user_access_token'], r.first['code_filename'])
        else
          return nil
        end
      end
    rescue => e
      # 失敗
      return nil
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
    user_coding = UserCoding.where(user_id: user_id)
    load_tree_html, load_user_codings = _mk_tree_path_html(data, user_coding, tree_state, code_state)
    return load_tree_html, load_user_codings, code_state
  end

  def self.upload(user_id, user_coding_id)
    begin
      ActiveRecord::Base.transaction do
        uc = UserCoding.find_by(id: user_coding_id, user_id: user_id, del_flg: false)
        if uc != nil
          ugcm = UserItemGalleryMap.find_by(user_id: user_id, del_flg: false)
        else
          # データ無し
          return true, I18n.t('message.database.item_state.save.error')
        end
      end
    rescue => e
      # 失敗
      return false, I18n.t('message.database.item_state.save.error')
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
          obj[n]['tree_value'] = user_coding_tree
        end
      end
    end
    return ret
  end

  def self._mk_tree_path_html(node, user_coding, tree_state, code_state, depth = 1)
    ret_html = ''
    load_user_codings = {}
    node.each do |k, v|
      if k == 'tree_value'
        next
      end

      file_key = v.keys.select{|s| s != 'tree_value'}.first
      value = v[file_key]
      user_coding_tree = v['tree_value']
      if value && !value.empty?
        child, child_load_user_codings = _mk_tree_path_html(v, user_coding, tree_state, code_state, depth + 1)
        load_user_codings.merge!(child_load_user_codings)
        # デフォルト開く状態
        opened = 'jstree-open'
        if tree_state &&
            tree_state[user_coding_tree[Const::Coding::Key::NODE_PATH]] &&
            tree_state[user_coding_tree[Const::Coding::Key::NODE_PATH]][Const::Coding::Key::IS_OPENED] &&
            tree_state[user_coding_tree[Const::Coding::Key::NODE_PATH]][Const::Coding::Key::IS_OPENED] == 'false'
          opened = ''
        end
        type = depth == 1 ? 'root' : 'folder'
        className = depth == 1 ? 'root' : 'folder'
        ret_html += "<li data-jstree='{\"type\":\"#{type}\"}' class='#{opened} #{className}'>#{k}<ul>#{child}</ul></li>"
      else
        load_user_codings[user_coding_tree['node_path']] = user_coding_tree['user_coding_id']
        selected = ''
        if code_state[user_coding_tree['user_coding_id']] &&
            code_state[user_coding_tree['user_coding_id']][Const::Coding::Key::IS_ACTIVE] &&
            code_state[user_coding_tree['user_coding_id']][Const::Coding::Key::IS_ACTIVE] == 'true'
          selected = ',"selected":"true"'
        end
        type = 'folder'
        className = 'folder'
        if user_coding_tree['user_coding_id']
          lang_type = user_coding.select{|uc| uc['id'].to_i == user_coding_tree['user_coding_id'].to_i}.first['lang_type']
          if lang_type == Const::Coding::Lang::JAVASCRIPT
            type = 'js_file'
            className = 'js'
          elsif lang_type == Const::Coding::Lang::COFFEESCRIPT
            type = 'coffee_file'
            className = 'coffee'
          end
        end
        ret_html += "<li data-jstree='{\"type\":\"#{type}\"#{selected}}' class='#{className}'>#{k}</li>"
      end
    end
    return ret_html, load_user_codings
  end

  def self._add_code(user_id, c)
    lang_type = c[Const::Coding::Key::LANG]
    draw_type = c[Const::Coding::Key::DRAW_TYPE]
    code = c[Const::Coding::Key::CODE]
    code_filename = generate_filename(user_id)
    user_access_token = User.find(user_id)['access_token']
    FileUtils.mkdir_p(_code_parentdirpath(user_access_token)) unless File.directory?(_code_parentdirpath(user_access_token))
    _save_code(user_access_token, code_filename, lang_type, code)
    uc = UserCoding.new({
                            user_id: user_id,
                            lang_type: lang_type,
                            draw_type: draw_type,
                            code_filename: code_filename
                        })
    uc.save!
    return uc.id
  end

  def self._update_code(user_id, codes)
    ret = []
    user_access_token = User.find(user_id)['access_token']
    FileUtils.mkdir_p(_code_parentdirpath(user_access_token)) unless File.directory?(_code_parentdirpath(user_access_token))
    codes.each do |c|
      user_coding_id = c[Const::Coding::Key::USER_CODING_ID]
      code = c[Const::Coding::Key::CODE]
      uc = UserCoding.find(user_coding_id)
      if uc != nil
        code_filename = uc['code_filename']
        _save_code(user_access_token, code_filename, uc['lang_type'], code)
        ret << uc.id
      else
        ret << nil
      end
    end
    return ret
  end

  def self._back_all_codes(user_id)
    # 全てのコードを背面にする
    code_state = get_code_state(user_id)
    code_state.each do |k, v|
      if code_state[k].nil?
        code_state[k] = {}
      end
      code_state[k][Const::Coding::Key::IS_OPENED] = false
      code_state[k][Const::Coding::Key::IS_ACTIVE] = false
    end
    Rails.cache.write(Const::Coding::CacheKey::CODE_STATE_KEY.gsub('@user_id', user_id.to_s), code_state, expires_in: 1.month)
  end

  def self._replace_all_tree(user_id, tree_data)
    ret = []
    # ツリーを一旦論理削除
    UserCodingTree.where(user_id: user_id, del_flg: false).update_all(del_flg: true)
    # ツリー状態を保存
    tree_data.each do |td|
      node_path = td[Const::Coding::Key::NODE_PATH]
      user_coding_id = td[Const::Coding::Key::USER_CODING_ID]
      uct = UserCodingTree.where(user_id: user_id, node_path: node_path)
      if uct.count == 0
        uct = UserCodingTree.new({
                                     user_id: user_id,
                                     node_path: node_path,
                                     user_coding_id: user_coding_id
                                 })
      else
        uct.user_coding_id = user_coding_id
        uct.del_flg = false
      end
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

  def self.generate_filename(user_id)
    tmp_token = SecureRandom.urlsafe_base64(10)
    UserCoding.find_by(user_id: user_id, code_filename: tmp_token).blank? ? tmp_token : generate_filename(user_id)
  end

  def self._code_parentdirpath(user_access_token)
    File.join(Rails.root, "/public#{USER_CODE_PATH}#{user_access_token}")
  end

  def self._code_filepath(user_access_token, code_filename)
    _code_parentdirpath(user_access_token) + "/#{code_filename}"
  end

  def self._code_urlpath(user_access_token, code_filename)
    "#{USER_CODE_PATH}#{user_access_token}/#{code_filename}"
  end

  def self._save_code(user_access_token, code_filename, lang_type, code)
    code_filepath = _code_filepath(user_access_token, code_filename)
    if lang_type == Const::Coding::Lang::COFFEESCRIPT
      coffee_filepath = code_filepath + COFFEESCRIPT_SUFFIX
      File.open(coffee_filepath,'w+') do |f|
        f.write(code)
      end
      # JSコンパイル
      File.open(code_filepath,'w') do |f|
        f.write(CoffeeScript.compile(File.read(coffee_filepath), bare: true))
      end
    else
      File.open(code_filepath,'w') do |file|
        file.write(code)
      end
    end
  end

  private_class_method :_mk_path_treedata, :_mk_tree_path_html, :_add_code, :_update_code, :_replace_all_tree, :_code_filepath

end