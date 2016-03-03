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

  constructor: (@userToken) ->

  # PageValueを保存
  saveAllPageValues: ->
    @saveGeneralPageValue()
    @saveInstancePageValue()
    @saveEventPageValue()
    @saveSettingPageValue()

  # PageValueを読み込み
  loadAllPageValues: ->
    @loadGeneralPageValue()
    @loadInstancePageValue()
    @loadEventPageValue()
    @loadSettingPageValue()

  # 保存時間が経過しているか
  isOverWorktableSaveTimeLimit: ->
    if !localStorage?
      return true

    key = @userToken
    time = 0
    if window.isItemPreview? && window.isItemPreview
      # アイテムプレビュー時
      return true

    if window.isWorkTable
      key += @constructor.Key.WORKTABLE_SAVETIME
      time = @constructor.WORKTABLE_SAVETIME
    else
      key += @constructor.Key.RUN_SAVETIME
      time = @constructor.RUN_SAVETIME

    if key != @userToken
      saveTime = localStorage.getItem(key)
      if !saveTime?
        return true
      diffTime = Common.calculateDiffTime($.now(), saveTime)
      return parseInt(diffTime.minutes) > time
    else
      return true

  generalKey : ->
    key = @userToken

    if window.isItemPreview? && window.isItemPreview
      # アイテムプレビュー時は保存しない
      return ''

    if window.isWorkTable
      key += @constructor.Key.WORKTABLE_GENERAL_PAGEVALUES
    else
      key += @constructor.Key.RUN_GENERAL_PAGEVALUES
    return key

  instanceKey : ->
    key = @userToken

    if window.isItemPreview? && window.isItemPreview
      # アイテムプレビュー時は保存しない
      return ''

    if window.isWorkTable
      key += @constructor.Key.WORKTABLE_INSTANCE_PAGEVALUES
    else
      key += @constructor.Key.RUN_INSTANCE_PAGEVALUES
    return key

  eventKey : ->
    key = @userToken

    if window.isItemPreview? && window.isItemPreview
      # アイテムプレビュー時は保存しない
      return ''

    if window.isWorkTable
      key += @constructor.Key.WORKTABLE_EVENT_PAGEVALUES
    else
      key += @constructor.Key.RUN_EVENT_PAGEVALUES
    return key

  settingKey : ->
    key = @userToken

    if window.isItemPreview? && window.isItemPreview
      # アイテムプレビュー時は保存しない
      return ''

    if window.isWorkTable
      key += @constructor.Key.WORKTABLE_SETTING_PAGEVALUES
    else
      key += @constructor.Key.RUN_SETTING_PAGEVALUES
    return key

  footprintKey : ->
    key = @userToken

    if window.isItemPreview? && window.isItemPreview
      # アイテムプレビュー時は保存しない
      return ''

    if !window.isWorkTable
      key += @constructor.Key.RUN_FOOTPRINT_PAGE_VALUES
    return key

  savetimeKey : ->
    key = @userToken

    if window.isItemPreview? && window.isItemPreview
      # アイテムプレビュー時は保存しない
      return ''

    if window.isWorkTable
      key += @constructor.Key.WORKTABLE_SAVETIME
    else
      key += @constructor.Key.RUN_SAVETIME
    return key

  savetime : ->
    time = 0
    if window.isWorkTable
      time = @constructor.WORKTABLE_SAVETIME
    else
      time = @constructor.RUN_SAVETIME
    return time

  # 全ワークテーブルキャッシュを消去
  clearWorktable: ->
    if localStorage?
      localStorage.removeItem(@constructor.Key.WORKTABLE_GENERAL_PAGEVALUES)
      localStorage.removeItem(@constructor.Key.WORKTABLE_INSTANCE_PAGEVALUES)
      localStorage.removeItem(@constructor.Key.WORKTABLE_EVENT_PAGEVALUES)
      localStorage.removeItem(@constructor.Key.WORKTABLE_SETTING_PAGEVALUES)
      localStorage.removeItem(@constructor.Key.WORKTABLE_SAVETIME)

  # 設定値以外のワークテーブルキャッシュを消去
  clearWorktableWithoutSetting: ->
    if localStorage?
      localStorage.removeItem(@constructor.Key.WORKTABLE_GENERAL_PAGEVALUES)
      localStorage.removeItem(@constructor.Key.WORKTABLE_INSTANCE_PAGEVALUES)
      localStorage.removeItem(@constructor.Key.WORKTABLE_EVENT_PAGEVALUES)
      localStorage.removeItem(@constructor.Key.WORKTABLE_SAVETIME)

  # 共通値と設定値以外のワークテーブルキャッシュを消去
  clearWorktableWithoutGeneralAndSetting: ->
    if localStorage?
      localStorage.removeItem(@constructor.Key.WORKTABLE_INSTANCE_PAGEVALUES)
      localStorage.removeItem(@constructor.Key.WORKTABLE_EVENT_PAGEVALUES)
      localStorage.removeItem(@constructor.Key.WORKTABLE_SAVETIME)

  # 実行画面キャッシュを消去
  clearRun: ->
    if localStorage?
      localStorage.removeItem(@constructor.Key.RUN_GENERAL_PAGEVALUES)
      localStorage.removeItem(@constructor.Key.RUN_INSTANCE_PAGEVALUES)
      localStorage.removeItem(@constructor.Key.RUN_EVENT_PAGEVALUES)
      localStorage.removeItem(@constructor.Key.RUN_SETTING_PAGEVALUES)
      localStorage.removeItem(@constructor.Key.RUN_FOOTPRINT_PAGE_VALUES)
      localStorage.removeItem(@constructor.Key.RUN_SAVETIME)

  # キャッシュに共通値を保存
  saveGeneralPageValue: ->
    key = @generalKey()
    if key != '' && localStorage?
      h = PageValue.getGeneralPageValue(PageValue.Key.G_PREFIX)
      localStorage.setItem(key, JSON.stringify(h))
      # 現在時刻を保存
      localStorage.setItem(@savetimeKey(), $.now())

  # キャッシュから共通値を読み込み
  loadGeneralValue: ->
    if localStorage?
      l = localStorage.getItem(@generalKey())
      if l?
        return JSON.parse(l)
      else
        return null
  loadGeneralPageValue: ->
    h = @loadGeneralValue()
    if h?
      PageValue.setGeneralPageValue(PageValue.Key.G_PREFIX, h)

  # キャッシュにインスタンス値を保存
  saveInstancePageValue: ->
    key = @instanceKey()
    if key != ''
      if localStorage?
        h = PageValue.getInstancePageValue(PageValue.Key.INSTANCE_PREFIX)
        localStorage.setItem(key, JSON.stringify(h))
        # 現在時刻を保存
        localStorage.setItem(@savetimeKey(), $.now())

  # キャッシュからインスタンス値を読み込み
  loadInstancePageValue: ->
    if localStorage?
      l = localStorage.getItem(@instanceKey())
      if l?
        h = JSON.parse(l)
        PageValue.setInstancePageValue(PageValue.Key.INSTANCE_PREFIX, h)

  # キャッシュにイベント値を保存
  saveEventPageValue: ->
    key = @eventKey()
    if key != '' && localStorage?
      h = PageValue.getEventPageValue(PageValue.Key.E_SUB_ROOT)
      localStorage.setItem(key, JSON.stringify(h))
      # 現在時刻を保存
      localStorage.setItem(@savetimeKey(), $.now())

  # キャッシュからイベント値を読み込み
  loadEventPageValue: ->
    if localStorage?
      l = localStorage.getItem(@eventKey())
      if l?
        h = JSON.parse(l)
        PageValue.setEventPageValue(PageValue.Key.E_SUB_ROOT, h)

  # キャッシュに共通設定値を保存
  saveSettingPageValue: ->
    key = @settingKey()
    if key != '' && localStorage?
      h = PageValue.getSettingPageValue(PageValue.Key.ST_PREFIX)
      localStorage.setItem(key, JSON.stringify(h))

  # キャッシュから共通設定値を読み込み
  loadSettingPageValue: ->
    if localStorage?
      l = localStorage.getItem(@settingKey())
      if l?
        h = JSON.parse(l)
        PageValue.setSettingPageValue(PageValue.Key.ST_PREFIX, h)

  # キャッシュに操作履歴値を保存
  saveFootprintPageValue: ->
    key = @footprintKey()
    if key != '' && localStorage?
      h = PageValue.getFootprintPageValue(PageValue.Key.F_PREFIX)
      localStorage.setItem(key, JSON.stringify(h))

  # キャッシュから操作履歴値を読み込み
  loadCommonFootprintPageValue: ->
    if localStorage?
      l = localStorage.getItem(@footprintKey())
      if l?
        h = JSON.parse(l)
        ret = {}
        for k, v of h
          if k.indexOf(PageValue.Key.P_PREFIX) < 0
            ret[k] = v
        PageValue.setFootprintPageValue(PageValue.Key.F_PREFIX, ret)

  loadPagingFootprintPageValue: (pageNum) ->
    if localStorage?
      l = localStorage.getItem(@footprintKey())
      if l?
        h = JSON.parse(l)
        ret = {}
        for k, v of h
          if k.indexOf(PageValue.Key.P_PREFIX) >= 0 && parseInt(k.replace(PageValue.Key.P_PREFIX, '')) == pageNum
            ret[k] = v
        PageValue.setFootprintPageValue(PageValue.Key.F_PREFIX, ret)

# インスタンスを作成
window.lStorage = new LocalStorage(utoken)