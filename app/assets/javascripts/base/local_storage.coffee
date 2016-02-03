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
    # @property [Int] WORKTABLE_SAVETIME 保存時間
    @WORKTABLE_SAVETIME = 'worktable_time'
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
    # @property [Int] RUN_SAVETIME 保存時間
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
    key = ''
    time = 0
    if window.isItemPreview? && window.isItemPreview
      # アイテムプレビュー時
      return true

    if window.isWorkTable
      key = @Key.WORKTABLE_SAVETIME
      time = @WORKTABLE_SAVETIME
    else
      key = @Key.RUN_SAVETIME
      time = @RUN_SAVETIME

    if key != ''
      lstorage = localStorage
      saveTime = lstorage.getItem(key)
      if !saveTime?
        return true
      diffTime = Common.calculateDiffTime($.now(), saveTime)
      return parseInt(diffTime.minutes) > time
    else
      return true

  @generalKey = ->
    key = ''

    if window.isItemPreview? && window.isItemPreview
      # アイテムプレビュー時は保存しない
      return ''

    if window.isWorkTable
      key = @Key.WORKTABLE_GENERAL_PAGEVALUES
    else
      key = @Key.RUN_GENERAL_PAGEVALUES
    return key

  @instanceKey = ->
    key = ''

    if window.isItemPreview? && window.isItemPreview
      # アイテムプレビュー時は保存しない
      return ''

    if window.isWorkTable
      key = @Key.WORKTABLE_INSTANCE_PAGEVALUES
    else
      key = @Key.RUN_INSTANCE_PAGEVALUES
    return key

  @eventKey = ->
    key = ''

    if window.isItemPreview? && window.isItemPreview
      # アイテムプレビュー時は保存しない
      return ''

    if window.isWorkTable
      key = @Key.WORKTABLE_EVENT_PAGEVALUES
    else
      key = @Key.RUN_EVENT_PAGEVALUES
    return key

  @settingKey = ->
    key = ''

    if window.isItemPreview? && window.isItemPreview
      # アイテムプレビュー時は保存しない
      return ''

    if window.isWorkTable
      key = @Key.WORKTABLE_SETTING_PAGEVALUES
    else
      key = @Key.RUN_SETTING_PAGEVALUES
    return key

  @footprintKey = ->
    key = ''

    if window.isItemPreview? && window.isItemPreview
      # アイテムプレビュー時は保存しない
      return ''

    if !window.isWorkTable
      key = @Key.RUN_FOOTPRINT_PAGE_VALUES
    return key

  @savetimeKey = ->
    key = ''

    if window.isItemPreview? && window.isItemPreview
      # アイテムプレビュー時は保存しない
      return ''

    if window.isWorkTable
      key = @Key.WORKTABLE_SAVETIME
    else
      key = @Key.RUN_SAVETIME
    return key

  @savetime = ->
    time = 0
    if window.isWorkTable
      time = @WORKTABLE_SAVETIME
    else
      time = @RUN_SAVETIME
    return time

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
    lstorage.removeItem(@Key.RUN_FOOTPRINT_PAGE_VALUES)
    lstorage.removeItem(@Key.RUN_SAVETIME)

  # キャッシュに共通値を保存
  @saveGeneralPageValue: ->
    key = @generalKey()
    if key != ''
      lstorage = localStorage
      h = PageValue.getGeneralPageValue(PageValue.Key.G_PREFIX)
      lstorage.setItem(key, JSON.stringify(h))
      # 現在時刻を保存
      lstorage.setItem(@savetimeKey(), $.now())

  # キャッシュから共通値を読み込み
  @loadGeneralValue: ->
    lstorage = localStorage
    l = lstorage.getItem(@generalKey())
    if l?
      return JSON.parse(l)
    else
      return null
  @loadGeneralPageValue: ->
    h = @loadGeneralValue()
    if h?
      PageValue.setGeneralPageValue(PageValue.Key.G_PREFIX, h)

  # キャッシュにインスタンス値を保存
  @saveInstancePageValue: ->
    key = @instanceKey()
    if key != ''
      lstorage = localStorage
      h = PageValue.getInstancePageValue(PageValue.Key.INSTANCE_PREFIX)
      lstorage.setItem(key, JSON.stringify(h))
      # 現在時刻を保存
      lstorage.setItem(@savetimeKey(), $.now())

  # キャッシュからインスタンス値を読み込み
  @loadInstancePageValue: ->
    lstorage = localStorage
    l = lstorage.getItem(@instanceKey())
    if l?
      h = JSON.parse(l)
      PageValue.setInstancePageValue(PageValue.Key.INSTANCE_PREFIX, h)

  # キャッシュにイベント値を保存
  @saveEventPageValue: ->
    key = @eventKey()
    if key != ''
      lstorage = localStorage
      h = PageValue.getEventPageValue(PageValue.Key.E_SUB_ROOT)
      lstorage.setItem(key, JSON.stringify(h))
      # 現在時刻を保存
      lstorage.setItem(@savetimeKey(), $.now())

  # キャッシュからイベント値を読み込み
  @loadEventPageValue: ->
    lstorage = localStorage
    l = lstorage.getItem(@eventKey())
    if l?
      h = JSON.parse(l)
      PageValue.setEventPageValue(PageValue.Key.E_SUB_ROOT, h)

  # キャッシュに共通設定値を保存
  @saveSettingPageValue: ->
    key = @settingKey()
    if key != ''
      lstorage = localStorage
      h = PageValue.getSettingPageValue(PageValue.Key.ST_PREFIX)
      lstorage.setItem(key, JSON.stringify(h))

  # キャッシュから共通設定値を読み込み
  @loadSettingPageValue: ->
    lstorage = localStorage
    l = lstorage.getItem(@settingKey())
    if l?
      h = JSON.parse(l)
      PageValue.setSettingPageValue(PageValue.Key.ST_PREFIX, h)

  # キャッシュに操作履歴値を保存
  @saveFootprintPageValue: ->
    key = @footprintKey()
    if key != ''
      lstorage = localStorage
      h = PageValue.getFootprintPageValue(PageValue.Key.F_PREFIX)
      lstorage.setItem(key, JSON.stringify(h))

  # キャッシュから操作履歴値を読み込み
  @loadCommonFootprintPageValue: ->
    lstorage = localStorage
    l = lstorage.getItem(@footprintKey())
    if l?
      h = JSON.parse(l)
      ret = {}
      for k, v of h
        if k.indexOf(PageValue.Key.P_PREFIX) < 0
          ret[k] = v
      PageValue.setFootprintPageValue(PageValue.Key.F_PREFIX, ret)

  @loadPagingFootprintPageValue: (pageNum) ->
    lstorage = localStorage
    l = lstorage.getItem(@footprintKey())
    if l?
      h = JSON.parse(l)
      ret = {}
      for k, v of h
        if k.indexOf(PageValue.Key.P_PREFIX) >= 0 && parseInt(k.replace(PageValue.Key.P_PREFIX, '')) == pageNum
          ret[k] = v
      PageValue.setFootprintPageValue(PageValue.Key.F_PREFIX, ret)