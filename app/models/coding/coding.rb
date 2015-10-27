require 'coding/gallery_coding'
require 'coding/user_coding'
require 'coding/user_gallery_coding_map'

class Coding
  def self.save_all(user_id, codes, tree_states)
    begin
      ActiveRecord::Base.transaction do
        _save_code(user_id, codes)
        _save_tree(user_id, tree_states)
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

  def self.save_tree(user_id, tree_states)
    begin
      ActiveRecord::Base.transaction do
        _save_tree(user_id, tree_states)
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
        return uc.to_h
      end
    rescue => e
      # 失敗
      return []
    end
  end

  def self.load_opened_code(user_id)
    begin
      ActiveRecord::Base.transaction do
        uc = UserCoding.where(user_id: user_id, is_opened: true, del_flg: false)
        return uc.to_h
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
        return _mk_path_treedata(uc.to_h)
      end
    rescue => e
      # 失敗
      return []
    end
  end

  def self.load_tree_html(user_id)
    data = load_code(user_id)
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
      node_path.each do |n|
        unless defined? obj[n]
          obj[n] = {}
        end
        obj = obj[n]
      end
      obj = user_coding_tree
    end
    return ret
  end

  def self._mk_tree_path_html(node)
    ret = ''
    node.each do |k, v|
      if v.is_a? Object
        child = _mk_tree_path_html(v)
        ret += "<li class='dir'>#{k}#{child}</li>"
      else
        input = ''
        v.each do |kk, vv|
          input += "<input type='hidden' class='#{kk}' value='#{vv}' />"
        end
        ret += "<li class='tip'>#{k}#{input}</li>"
      end
    end
    if ret.length > 0
      ret = "<ul>#{ret}</ul>"
    end
    return ret
  end

  def self._save_code(user_id, codes)
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
    end
  end

  def self._save_tree(user_id, tree_states)
    # ツリーを論理削除
    UserCodingTree.where(user_id: user_id, del_flg: false).update_all(del_flg: true)
    # ツリー状態を保存
    tree_states.each do |tree_state|
      name = tree_state[Const::Coding::Key::NAME]
      node_path = tree_state[Const::Coding::Key::NODE_PATH]
      is_opened =  tree_state[Const::Coding::Key::IS_OPENED]
      uct = UserCodingTree.new({
                                   user_id: user_id,
                                   name: name,
                                   node_path: node_path,
                                   is_opened: is_opened
                               })
      uct.save!
    end
  end

  private_class_method :_mk_path_treedata, :_mk_tree_path_html, :_save_code, :_save_tree

end