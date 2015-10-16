require 'common/const'

class MotionCheckController < ApplicationController
  def index
    # リクエストサイズ表示
    p "content_length: #{request.content_length}"

    # Constantの設定
    init_const

    setup_run_data
  end

  def paging
    # Constantの設定
    init_const

    user_id = current_or_guest_user.id
    target_pages = params['targetPages']
    # cacheから読み込み
    instance = Rails.cache.read("user_id:#{user_id}-instance")
    event = Rails.cache.read("user_id:#{user_id}-event")
    if instance == nil || event == nil
      # TODO: DBから読み込み
    end
    ins = {}
    ent = {}
    for i in target_pages
      ins[Const::PageValueKey::P_PREFIX + i] = instance[Const::PageValueKey::P_PREFIX + i]
      ent[Const::PageValueKey::P_PREFIX + i] = event[Const::PageValueKey::P_PREFIX + i]
    end
    @instance_pagevalue_hash = ins
    @event_pagevalue_hash = ent
  end

  def new_window
    # Constantの設定
    init_const

    setup_run_data
  end

  private
  def setup_run_data
    @is_runwindow_reload = !request.post?
    unless @is_runwindow_reload
      user_id = current_or_guest_user.id
      page_num = params['page_num']
      if page_num == nil
        page_num = 1
      end
      general = params.require(Const::PageValueKey::G_PREFIX.to_sym)
      instance = params.require(Const::PageValueKey::INSTANCE_PREFIX.to_sym)
      event = params.require(Const::PageValueKey::E_SUB_ROOT.to_sym)
      @pagevalues, @creator = Run.setup_data(user_id, general, instance, event, page_num)
    end
  end

end
