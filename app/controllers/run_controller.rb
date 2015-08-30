class RunController < ApplicationController
  def index
    # リクエストサイズ表示
    p "content_length: #{request.content_length}"

    # Constantの設定
    init_const

    @is_runwindow_reload = !request.post?
    unless @is_runwindow_reload
      user_id = current_user.id
      general = params.require(Const::PageValueKey::G_PREFIX.to_sym)
      instance = params.require(Const::PageValueKey::INSTANCE_PREFIX.to_sym)
      event = params.require(Const::PageValueKey::E_PREFIX.to_sym)
      # cacheに保存
      Rails.cache.write("user_id:#{user_id}-instance", instance)
      Rails.cache.write("user_id:#{user_id}-event", event)
      @general_pagevalues = Run.make_pagevalue(general, Const::PageValueKey::G_PREFIX)
      @instance_pagevalues = Run.make_pagevalue_with_pagenum(instance, Const::PageValueKey::INSTANCE_PREFIX, 1)
      @event_pagevalues = Run.make_pagevalue_with_pagenum(event, Const::PageValueKey::E_PREFIX, 1)
    end
  end

  def paging
    # Constantの設定
    init_const

    user_id = current_user.id
    page_num = params['page_num']
    # cacheから読み込み
    instance = Rails.cache.read("user_id:#{user_id}-instance")
    event = Rails.cache.read("user_id:#{user_id}-event")
    instance_paging = instance[Const::PageValueKey::P_PREFIX + page_num]
    event_paging = event[Const::PageValueKey::P_PREFIX + page_num]
    @instance_pagevalue_hash = instance_paging
    @event_pagevalue_hash = event_paging
  end
end
