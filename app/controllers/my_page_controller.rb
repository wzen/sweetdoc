require 'gallery/gallery'
require 'item_gallery/item_gallery'

class MyPageController < ApplicationController
  before_action :redirect_if_not_login

  def created_contents
    user_id = _get_user_id
    head = params.fetch(Const::MyPage::Key::HEAD, 0)
    limit = params.fetch(Const::MyPage::Key::LIMIT, 30)
    if user_id
      @user = User.find(user_id)
      @contents = Gallery.created_contents_list(user_id, head, limit)
    else
      # エラー
    end
  end

  def remove_contents
    user_id = _get_user_id
    gallery_access_token = params.require(Const::Gallery::Key::GALLERY_ACCESS_TOKEN)
    Gallery.remove_contents(user_id, gallery_access_token)
    redirect_to action: 'created_contents'
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
      @contents = Gallery.bookmarks_list(user_id, head, limit)
    else
      # エラー
    end
  end

  def remove_bookmark
    user_id = _get_user_id
    gallery_access_token = params.require(Const::Gallery::Key::GALLERY_ACCESS_TOKEN)
    @result_success, @message = Gallery.remove_bookmark(user_id, gallery_access_token, Date.today)
    redirect_to action: 'bookmarks'
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
