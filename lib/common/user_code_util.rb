class UserCodeUtil
  USER_CODE_PATH = '/user_code/'
  ITEM_GALLERY_PATH = '/item_gallery/'
  COFFEESCRIPT_SUFFIX = '__cbase'

  module CODE_TYPE
    ITEM_PREVIEW = 'ip'
    ITEM_GALLERY = 'ig'
  end

  def self.code_parentdirpath(type, user_access_token)
    if type == CODE_TYPE::ITEM_PREVIEW
      return File.join(Rails.root, "/public#{USER_CODE_PATH}#{user_access_token}")
    elsif type == CODE_TYPE::ITEM_GALLERY
      return File.join(Rails.root, "/public#{ITEM_GALLERY_PATH}#{user_access_token}")
    end
    nil
  end

  def self.code_filepath(type, user_access_token, code_filename)
    code_parentdirpath(type, user_access_token) + "/#{code_filename}"
  end

  def self.code_urlpath(type, user_access_token, code_filename)
    if type == CODE_TYPE::ITEM_PREVIEW
      return "#{USER_CODE_PATH}#{user_access_token}/#{code_filename}"
    elsif type == CODE_TYPE::ITEM_GALLERY
      return "#{ITEM_GALLERY_PATH}#{user_access_token}/#{code_filename}"
    end
    nil
  end

  def self.add_code(type, user_id, c)
    lang_type = c[Const::Coding::Key::LANG]
    draw_type = c[Const::Coding::Key::DRAW_TYPE]
    code = c[Const::Coding::Key::CODE]
    code_filename = generate_filename(user_id)
    user_access_token = User.find(user_id)['access_token']
    FileUtils.mkdir_p(code_parentdirpath(type, user_access_token)) unless File.directory?(code_parentdirpath(type, user_access_token))
    save_code(type, user_access_token, code_filename, lang_type, code)
    uc = UserCoding.new({
                            user_id: user_id,
                            lang_type: lang_type,
                            draw_type: draw_type,
                            code_filename: code_filename
                        })
    uc.save!
    return uc.id
  end

  def self.update_code(type, user_id, codes)
    ret = []
    user_access_token = User.find(user_id)['access_token']
    FileUtils.mkdir_p(code_parentdirpath(type, user_access_token)) unless File.directory?(code_parentdirpath(type, user_access_token))
    codes.each do |c|
      user_coding_id = c[Const::Coding::Key::USER_CODING_ID]
      code = c[Const::Coding::Key::CODE]
      uc = UserCoding.find(user_coding_id)
      if uc != nil
        code_filename = uc['code_filename']
        save_code(type, user_access_token, code_filename, uc['lang_type'], code)
        ret << uc.id
      else
        ret << nil
      end
    end
    return ret
  end

  def self.save_code(type, user_access_token, code_filename, lang_type, code)
    code_filepath = code_filepath(type, user_access_token, code_filename)
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
end