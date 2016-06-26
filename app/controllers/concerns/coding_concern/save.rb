module CodingConcern
  module Save
    def save_coding_all(user_id, codes, tree_data)
      begin
        ActiveRecord::Base.transaction do
          UserCodeUtil.update_code(UserCodeUtil::CODE_TYPE::ITEM_PREVIEW, user_id, codes)
          _replace_all_tree(user_id, tree_data)
        end
        return true, I18n.t('message.database.item_state.save.success')
      rescue => e
        # 失敗
        return false, I18n.t('message.database.item_state.save.error')
      end
    end

    def update_coding_data(user_id, codes)
      begin
        ActiveRecord::Base.transaction do
          UserCodeUtil.update_code(UserCodeUtil::CODE_TYPE::ITEM_PREVIEW, user_id, codes)
        end
        return true, I18n.t('message.database.item_state.save.success')
      rescue => e
        # 失敗
        return false, I18n.t('message.database.item_state.save.error')
      end
    end

    def save_coding_state(user_id, tree_data, codes)
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

    def add_coding_new_file(user_id, node_path, lang_type, draw_type)
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

    def add_coding_new_folder(user_id, node_path)
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

    def delete_coding_node(user_id, node_path)
      begin
        ActiveRecord::Base.transaction do
          uct = UserCodingTree.where('user_id = ? AND node_path LIKE ? AND del_flg = 0', user_id, "%#{_escape_like(node_path)}%")
          uct.each do |u|
            if u['user_coding_id']
              uc = UserCoding.find(u['user_coding_id'])
              if uc.present?
                uc.del_flg = true
                uc.save!
              end
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

    def save_coding_tree(user_id, tree_data)
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

    private
    def _save_tree(user_id, tree_data)
      node_path = tree_data[Const::Coding::Key::NODE_PATH]
      user_coding_id = tree_data[Const::Coding::Key::USER_CODING_ID]
      uct = UserCodingTree.find_by(user_id: user_id, node_path: node_path, del_flg: false)
      if uct.blank?
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

    def _add_code(user_id, c)
      lang_type = c[Const::Coding::Key::LANG]
      draw_type = c[Const::Coding::Key::DRAW_TYPE]
      code = c[Const::Coding::Key::CODE]
      code_filename = generate_filename(user_id)
      user_access_token = User.find(user_id)['access_token']
      FileUtils.mkdir_p(UserCodeUtil.code_parentdirpath(UserCodeUtil::CODE_TYPE::ITEM_PREVIEW, user_access_token)) unless File.directory?(UserCodeUtil.code_parentdirpath(UserCodeUtil::CODE_TYPE::ITEM_PREVIEW, user_access_token))
      UserCodeUtil.save_code(UserCodeUtil::CODE_TYPE::ITEM_PREVIEW, user_access_token, code_filename, lang_type, code)
      uc = UserCoding.new({
                              user_id: user_id,
                              lang_type: lang_type,
                              draw_type: draw_type,
                              code_filename: code_filename
                          })
      uc.save!
      return uc.id
    end

    def _back_all_codes(user_id)
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

    # ActiveRecord Like エスケープ
    def _escape_like(string)
      string.gsub(/[\\%_]/){|m| "\\#{m}"}
    end

  end
end