require 'gallery/gallery'
require 'item_gallery/item_gallery'

class MyPageController < ApplicationController

  def created_contents
    user_id = _get_user_id
    head = params.fetch(Const::MyPage::Key::HEAD, 0)
    limit = params.fetch(Const::MyPage::Key::LIMIT, 30)
    if user_id
      @user = User.find(user_id)
      @contents = Gallery.created_contents(user_id, head, limit)
    else
      # エラー
    end
  end

  def created_items
    user_id = _get_user_id
    head = params.fetch(Const::MyPage::Key::HEAD, 0)
    limit = params.fetch(Const::MyPage::Key::LIMIT, 30)
    if user_id
      @user = User.find(user_id)
      @contents = ItemGallery.created_items(user_id, head, limit)
    else
      # エラー
    end
  end

  def bookmarks
    user_id = _get_user_id
    head = params.fetch(Const::MyPage::Key::HEAD, 0)
    limit = params.fetch(Const::MyPage::Key::LIMIT, 30)
    if user_id
      @user = User.find(user_id)
      @contents = Gallery.bookmarks(user_id, head, limit)
    else
      # エラー
    end
  end

  def using_items
    user_id = _get_user_id
    head = params.fetch(Const::MyPage::Key::HEAD, 0)
    limit = params.fetch(Const::MyPage::Key::LIMIT, 30)
    if user_id
      @user = User.find(user_id)
      @contents = ItemGallery.using_items(user_id, head, limit)
    else
      # エラー
    end
  end

  private
  def _get_user_id
    user_access_token = params.fetch(Const::User::Key::USER_ACCESS_TOKEN, nil)
    if user_access_token
      user = User.find_by(access_token: user_access_token, del_flg: false)
      if user
        # 指定ユーザのページ表示
        @is_accessed_myself_page = false
        return user.user_id
      end
    end
    # 自分のページを表示
    @is_accessed_myself_page = true
    current_or_guest_user.id
  end
end
