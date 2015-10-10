require 'common/const'

class RunController < ApplicationController
  def index
    # リクエストサイズ表示
    p "content_length: #{request.content_length}"

    # Constantの設定
    init_const

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
      # cacheに保存
      Rails.cache.write("user_id:#{user_id}-instance", instance, expires_in: 1.hour)
      Rails.cache.write("user_id:#{user_id}-event", event, expires_in: 1.hour)

      # TODO: DB保存処理

      @general_pagevalues = Run.make_pagevalue(general, Const::PageValueKey::G_PREFIX)
      @instance_pagevalues = Run.make_pagevalue_with_pagenum(instance, Const::PageValueKey::INSTANCE_PREFIX, page_num)
      @event_pagevalues = Run.make_pagevalue_with_pagenum(event, Const::PageValueKey::E_SUB_ROOT, page_num)
    end
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

  def markitup_preview
    render layout: false
  end
end
