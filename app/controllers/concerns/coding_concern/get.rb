module CodingConcern
  module Get

    def load_coding_data(user_id, user_coding_id = nil)
      begin
        ActiveRecord::Base.transaction do
          u_sql = ''
          if user_coding_id
            u_sql = "AND uc.id = #{user_coding_id.to_i}"
          end
          sql =<<-"SQL"
          SELECT uc.code_filename as code_filename, uct.node_path as node_path, uc.lang_type as lang_type, uc.id as id, u.access_token as user_access_token
          FROM user_codings uc
          RIGHT JOIN user_coding_trees uct ON uc.user_id = uct.user_id AND uc.del_flg = 0 AND uct.del_flg = 0
          INNER JOIN users u ON uc.user_id = u.id
          AND uc.id = uct.user_coding_id
          AND u.del_flg = 0
          WHERE u.id = #{user_id.to_i} #{u_sql}
          SQL
          ret_sql = ActiveRecord::Base.connection.select_all(sql)
          ret = ret_sql.to_hash

          ret = ret.map do |m|
            user_access_token = m['user_access_token']
            nodes = m['node_path'].split('/')
            m['name'] = nodes[nodes.length - 1]
            filepath = UserCodeUtil.code_filepath(UserCodeUtil::CODE_TYPE::ITEM_PREVIEW, user_access_token, m['code_filename'])
            if m['lang_type'] == Const::Coding::Lang::COFFEESCRIPT
              filepath += UserCodeUtil::COFFEESCRIPT_SUFFIX
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

    def load_opened_coding_data(user_id)
      begin
        ActiveRecord::Base.transaction do
          sql =<<-"SQL"
          SELECT uc.code_filename as code_filename, uct.node_path as node_path, uc.lang_type as lang_type, uc.id as id, u.access_token as user_access_token
          FROM user_codings uc
          RIGHT JOIN user_coding_trees uct ON uc.user_id = uct.user_id AND uc.del_flg = 0 AND uct.del_flg = 0
          INNER JOIN users u ON uc.user_id = u.id
          AND uc.id = uct.user_coding_id
          AND u.del_flg = 0
          WHERE u.id = #{user_id.to_i}
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
            filepath = UserCodeUtil.code_filepath(UserCodeUtil::CODE_TYPE::ITEM_PREVIEW, user_access_token, m['code_filename'])
            if m['lang_type'] == Const::Coding::Lang::COFFEESCRIPT
              filepath += UserCodeUtil::COFFEESCRIPT_SUFFIX
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

    def code_source_path(user_id, user_coding_id)
      begin
        ActiveRecord::Base.transaction do
          sql =<<-"SQL"
          SELECT uc.code_filename as code_filename, uc.lang_type as lang_type, u.access_token as user_access_token
          FROM user_codings uc
          INNER JOIN users u ON uc.user_id = u.id
          WHERE u.id = #{user_id.to_i}
          AND u.del_flg = 0
          AND uc.id = #{user_coding_id.to_i}
          AND uc.del_flg = 0
          SQL
          ret_sql = ActiveRecord::Base.connection.select_all(sql)
          r = ret_sql.to_hash
          if r.count > 0
            return UserCodeUtil.code_urlpath(UserCodeUtil::CODE_TYPE::ITEM_PREVIEW, r.first['user_access_token'], r.first['code_filename'])
          else
            return nil
          end
        end
      rescue => e
        # 失敗
        return nil
      end
    end

    def load_treedata(user_id)
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

    def load_coding_item_data(user_id)
      data = load_treedata(user_id)
      tree_state = get_tree_state(user_id)
      code_state = get_code_state(user_id)
      user_coding = UserCoding.where(user_id: user_id, del_flg: false)
      load_tree_html, load_user_codings = _mk_tree_path_html(data, user_coding, tree_state, code_state)
      return load_tree_html, load_user_codings, code_state
    end

    def get_tree_state(user_id)
      r = Rails.cache.read(Const::Coding::CacheKey::TREE_STATE_KEY.gsub('@user_id', user_id.to_s))
      return r ? r : {}
    end

    def get_code_state(user_id)
      r = Rails.cache.read(Const::Coding::CacheKey::CODE_STATE_KEY.gsub('@user_id', user_id.to_s))
      return r ? r : {}
    end

    def generate_filename(user_id)
      tmp_token = SecureRandom.urlsafe_base64(10)
      UserCoding.find_by(user_id: user_id, code_filename: tmp_token, del_flg: false).blank? ? tmp_token : generate_filename(user_id)
    end


    private
    def _mk_path_treedata(user_coding_trees)
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

    def _mk_tree_path_html(node, user_coding, tree_state, code_state, depth = 1)
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

    def _replace_all_tree(user_id, tree_data)
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

  end
end