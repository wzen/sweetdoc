require 'mypage/mypage'

class MyPageController < ApplicationController

  def created_contents
    user_id = _get_user_id
    if user_id
      @user = User.find(user_id)
      @contents = MyPage.created_contents(user_id)
    else
      # エラー
    end
  end

  def created_items
    user_id = _get_user_id
    if user_id
      @user = User.find(user_id)
      @contents = MyPage.created_items(user_id)
    else
      # エラー
    end
  end

  def bookmarks
    user_id = _get_user_id
    if user_id
      @user = User.find(user_id)
      @contents = MyPage.bookmarks(user_id)
    else
      # エラー
    end
  end

  def using_items
    user_id = _get_user_id
    if user_id
      @user = User.find(user_id)
      @contents = MyPage.using_items(user_id)
    else
      # エラー
    end
  end

  private
  def _get_user_id
    user_access_token = params.fetch(Const::MyPage::Key::USER_ACCESS_TOKEN, nil)
    if user_access_token
      user = User.find_by(access_token: user_access_token)
      if user
        return user.user_id
      end
    else
      # 自分のページを表示
      return current_or_guest_user.id
    end
    nil
  end
end
