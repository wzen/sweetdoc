# WebStorage
class LocalStorage

  class @Key
    # @property [Int] WORKTABLE_EVENT_PAGEVALUES アイテム情報
    @WORKTABLE_GENERAL_PAGEVALUES = 'worktable_general_pagevalues'
    # @property [Int] WORKTABLE_EVENT_PAGEVALUES アイテム情報
    @WORKTABLE_INSTANCE_PAGEVALUES = 'worktable_instance_pagevalues'
    # @property [Int] WORKTABLE_EVENT_PAGEVALUES イベント
    @WORKTABLE_EVENT_PAGEVALUES = 'worktable_event_pagevalues'
    # @property [Int] WORKTABLE_SETTING_PAGEVALUES 共通設定
    @WORKTABLE_SETTING_PAGEVALUES = 'worktable_setting_pagevalues'
    # @property [Int] WORKTABLE_EVENT_PAGEVALUES アイテム情報
    @RUN_GENERAL_PAGEVALUES = 'run_general_pagevalues'
    # @property [Int] WORKTABLE_EVENT_PAGEVALUES アイテム情報
    @RUN_INSTANCE_PAGEVALUES = 'run_instance_pagevalues'
    # @property [Int] WORKTABLE_EVENT_PAGEVALUES イベント
    @RUN_EVENT_PAGEVALUES = 'run_event_pagevalues'
    # @property [Int] WORKTABLE_SETTING_PAGEVALUES 共通設定
    @RUN_SETTING_PAGEVALUES = 'run_setting_pagevalues'
    # @property [Int] RUN_FOOTPRINT_PAGE_VALUES 操作履歴
    @RUN_FOOTPRINT_PAGE_VALUES = 'run_footprint_pagevalues'
    # @property [Int] WORKTABLE_SAVETIME 保存時間
    @WORKTABLE_SAVETIME = 'worktable_time'
    # @property [Int] WORKTABLE_SAVETIME 保存時間
    @RUN_SAVETIME = 'run_time'

  @WORKTABLE_SAVETIME = 5
  @RUN_SAVETIME = 9999

  # PageValueを保存
  @saveAllPageValues: ->
    @saveGeneralPageValue()
    @saveInstancePageValue()
    @saveEventPageValue()
    @saveSettingPageValue()

  # PageValueを読み込み
  @loadAllPageValues: ->
    @loadGeneralPageValue()
    @loadInstancePageValue()
    @loadEventPageValue()
    @loadSettingPageValue()

  # 保存時間が経過しているか
  @isOverWorktableSaveTimeLimit: ->
    isRun = !window.isWorkTable
    lstorage = localStorage
    key = if isRun then @Key.RUN_SAVETIME else @Key.WORKTABLE_SAVETIME
    saveTime = lstorage.getItem(key)
    if !saveTime?
      return true
    diffTime = Common.calculateDiffTime($.now(), saveTime)
    time = if isRun then @RUN_SAVETIME else @WORKTABLE_SAVETIME
    return parseInt(diffTime.minutes) > time

  # 全ワークテーブルキャッシュを消去
  @clearWorktable: ->
    lstorage = localStorage
    lstorage.removeItem(@Key.WORKTABLE_GENERAL_PAGEVALUES)
    lstorage.removeItem(@Key.WORKTABLE_INSTANCE_PAGEVALUES)
    lstorage.removeItem(@Key.WORKTABLE_EVENT_PAGEVALUES)
    lstorage.removeItem(@Key.WORKTABLE_SETTING_PAGEVALUES)
    lstorage.removeItem(@Key.WORKTABLE_SAVETIME)

  # 設定値以外のワークテーブルキャッシュを消去
  @clearWorktableWithoutSetting: ->
    lstorage = localStorage
    lstorage.removeItem(@Key.WORKTABLE_GENERAL_PAGEVALUES)
    lstorage.removeItem(@Key.WORKTABLE_INSTANCE_PAGEVALUES)
    lstorage.removeItem(@Key.WORKTABLE_EVENT_PAGEVALUES)
    lstorage.removeItem(@Key.WORKTABLE_SAVETIME)

  # 共通値と設定値以外のワークテーブルキャッシュを消去
  @clearWorktableWithoutGeneralAndSetting: ->
    lstorage = localStorage
    lstorage.removeItem(@Key.WORKTABLE_INSTANCE_PAGEVALUES)
    lstorage.removeItem(@Key.WORKTABLE_EVENT_PAGEVALUES)
    lstorage.removeItem(@Key.WORKTABLE_SAVETIME)

  # 実行画面キャッシュを消去
  @clearRun: ->
    lstorage = localStorage
    lstorage.removeItem(@Key.RUN_GENERAL_PAGEVALUES)
    lstorage.removeItem(@Key.RUN_INSTANCE_PAGEVALUES)
    lstorage.removeItem(@Key.RUN_EVENT_PAGEVALUES)
    lstorage.removeItem(@Key.RUN_SETTING_PAGEVALUES)
    lstorage.removeItem(@Key.RUN_SAVETIME)

  # キャッシュに共通値を保存
  @saveGeneralPageValue: ->
    isRun = !window.isWorkTable
    lstorage = localStorage
    h = PageValue.getGeneralPageValue(PageValue.Key.G_PREFIX)
    key = if isRun then @Key.RUN_GENERAL_PAGEVALUES else @Key.WORKTABLE_GENERAL_PAGEVALUES
    lstorage.setItem(key, JSON.stringify(h))
    # 現在時刻を保存
    key = if isRun then @Key.RUN_SAVETIME else @Key.WORKTABLE_SAVETIME
    lstorage.setItem(key, $.now())

  # キャッシュから共通値を読み込み
  @loadGeneralPageValue: ->
    isRun = !window.isWorkTable
    lstorage = localStorage
    key = if isRun then @Key.RUN_GENERAL_PAGEVALUES else @Key.WORKTABLE_GENERAL_PAGEVALUES
    h = JSON.parse(lstorage.getItem(key))
    PageValue.setGeneralPageValue(PageValue.Key.G_PREFIX, h)

  # キャッシュにインスタンス値を保存
  @saveInstancePageValue: ->
    isRun = !window.isWorkTable
    lstorage = localStorage
    h = PageValue.getInstancePageValue(PageValue.Key.INSTANCE_PREFIX)
    key = if isRun then @Key.RUN_INSTANCE_PAGEVALUES else @Key.WORKTABLE_INSTANCE_PAGEVALUES
    lstorage.setItem(key, JSON.stringify(h))
    # 現在時刻を保存
    key = if isRun then @Key.RUN_SAVETIME else @Key.WORKTABLE_SAVETIME
    lstorage.setItem(key, $.now())

  # キャッシュからインスタンス値を読み込み
  @loadInstancePageValue: ->
    isRun = !window.isWorkTable
    lstorage = localStorage
    key = if isRun then @Key.RUN_INSTANCE_PAGEVALUES else @Key.WORKTABLE_INSTANCE_PAGEVALUES
    h = JSON.parse(lstorage.getItem(key))
    PageValue.setInstancePageValue(PageValue.Key.INSTANCE_PREFIX, h)

  # キャッシュにイベント値を保存
  @saveEventPageValue: ->
    isRun = !window.isWorkTable
    lstorage = localStorage
    h = PageValue.getEventPageValue(PageValue.Key.E_SUB_ROOT)
    key = if isRun then @Key.RUN_EVENT_PAGEVALUES else @Key.WORKTABLE_EVENT_PAGEVALUES
    lstorage.setItem(key, JSON.stringify(h))
    # 現在時刻を保存
    key = if isRun then @Key.RUN_SAVETIME else @Key.WORKTABLE_SAVETIME
    lstorage.setItem(key, $.now())

  # キャッシュからイベント値を読み込み
  @loadEventPageValue: ->
    isRun = !window.isWorkTable
    lstorage = localStorage
    key = if isRun then @Key.RUN_EVENT_PAGEVALUES else @Key.WORKTABLE_EVENT_PAGEVALUES
    h = JSON.parse(lstorage.getItem(key))
    PageValue.setEventPageValue(PageValue.Key.E_SUB_ROOT, h)

  # キャッシュに共通設定値を保存
  @saveSettingPageValue: ->
    isRun = !window.isWorkTable
    lstorage = localStorage
    h = PageValue.getSettingPageValue(PageValue.Key.ST_PREFIX)
    key = if isRun then @Key.RUN_SETTING_PAGEVALUES else @Key.WORKTABLE_SETTING_PAGEVALUES
    lstorage.setItem(key, JSON.stringify(h))

  # キャッシュから共通設定値を読み込み
  @loadSettingPageValue: ->
    isRun = !window.isWorkTable
    lstorage = localStorage
    key = if isRun then @Key.RUN_SETTING_PAGEVALUES else @Key.WORKTABLE_SETTING_PAGEVALUES
    h = JSON.parse(lstorage.getItem(key))
    PageValue.setSettingPageValue(PageValue.Key.ST_PREFIX, h)

  # キャッシュに操作履歴値を保存
  @saveFootprintPageValue: ->
    lstorage = localStorage
    h = PageValue.getFootprintPageValue(PageValue.Key.F_PREFIX)
    lstorage.setItem(@Key.RUN_FOOTPRINT_PAGE_VALUES, JSON.stringify(h))

  # キャッシュから操作履歴値を読み込み
  @loadCommonFootprintPageValue: ->
    lstorage = localStorage
    h = JSON.parse(lstorage.getItem(@Key.RUN_FOOTPRINT_PAGE_VALUES))
    ret = {}
    for k, v of h
      if k.indexOf(PageValue.Key.P_PREFIX) < 0
        ret[k] = v
    PageValue.setFootprintPageValue(PageValue.Key.F_PREFIX, ret)

  @loadPagingFootprintPageValue: (pageNum) ->
    lstorage = localStorage
    h = JSON.parse(lstorage.getItem(@Key.RUN_FOOTPRINT_PAGE_VALUES))
    ret = {}
    for k, v of h
      if k.indexOf(PageValue.Key.P_PREFIX) >= 0 && parseInt(k.replace(PageValue.Key.P_PREFIX, '')) == pageNum
        ret[k] = v
    PageValue.setFootprintPageValue(PageValue.Key.F_PREFIX, ret)