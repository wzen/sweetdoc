class LocalStorage

  class @Key
    # @property [Int] WORKTABLE_EVENT_PAGEVALUES アイテム情報
    @WORKTABLE_PAGEVALUES = 'worktable_pagevalues'
    # @property [Int] WORKTABLE_EVENT_PAGEVALUES イベント
    @WORKTABLE_EVENT_PAGEVALUES = 'worktable_event_pagevalues'
    # @property [Int] WORKTABLE_SETTING_PAGEVALUES 共通設定
    @WORKTABLE_SETTING_PAGEVALUES = 'worktable_setting_pagevalues'
    # @property [Int] WORKTABLE_EVENT_PAGEVALUES アイテム情報
    @RUN_PAGEVALUES = 'run_pagevalues'
    # @property [Int] WORKTABLE_EVENT_PAGEVALUES イベント
    @RUN_EVENT_PAGEVALUES = 'run_event_pagevalues'
    # @property [Int] WORKTABLE_SETTING_PAGEVALUES 共通設定
    @RUN_SETTING_PAGEVALUES = 'run_setting_pagevalues'
    # @property [Int] WORKTABLE_SAVETIME 保存時間
    @WORKTABLE_SAVETIME = 'worktable_time'
    # @property [Int] WORKTABLE_SAVETIME 保存時間
    @RUN_SAVETIME = 'run_time'

  @WORKTABLE_SAVETIME = 5
  @RUN_SAVETIME = 9999

  @loadValueForWorktable: ->
    @loadPageValue()
    @loadEventPageValue()
    @loadSettingPageValue()

  @saveValueForRun: ->
    @savePageValue(true)
    @saveEventPageValue(true)
    @saveSettingPageValue(true)

  @loadValueForRun: ->
    @loadPageValue(true)
    @loadEventPageValue(true)
    @loadSettingPageValue(true)

  # 保存時間が経過しているか
  @isOverWorktableSaveTimeLimit: (isRun = false) ->
    lstorage = localStorage
    key = if isRun then @Key.RUN_SAVETIME else @Key.WORKTABLE_SAVETIME
    saveTime = lstorage.getItem(key)
    if !saveTime?
      return true
    duration = $.now() - saveTime
    d = new Date(duration)
    m = d.getMinutes()
    time = if isRun then @RUN_SAVETIME else @WORKTABLE_SAVETIME
    return parseInt(m) > time

  # 保存を消去
  @clearWorktable: ->
    lstorage = localStorage
    lstorage.removeItem(@Key.WORKTABLE_PAGEVALUES)
    lstorage.removeItem(@Key.WORKTABLE_EVENT_PAGEVALUES)
    lstorage.removeItem(@Key.WORKTABLE_SETTING_PAGEVALUES)

  # ストレージにアイテム値を保存
  @savePageValue: (isRun = false) ->
    lstorage = localStorage
    h = PageValue.getInstancePageValue(PageValue.Key.INSTANCE_PREFIX)
    key = if isRun then @Key.RUN_PAGEVALUES else @Key.WORKTABLE_PAGEVALUES
    lstorage.setItem(key, JSON.stringify(h))
    # 現在時刻を保存
    key = if isRun then @Key.RUN_SAVETIME else @Key.WORKTABLE_SAVETIME
    lstorage.setItem(key, $.now())

  # ストレージからアイテム値を読み込み
  @loadPageValue: (isRun = false) ->
    lstorage = localStorage
    key = if isRun then @Key.RUN_PAGEVALUES else @Key.WORKTABLE_PAGEVALUES
    h = JSON.parse(lstorage.getItem(key))
    for k, v of h
      PageValue.setInstancePageValue(PageValue.Key.INSTANCE_PREFIX + PageValue.Key.PAGE_VALUES_SEPERATOR + k, v)

  # ストレージにイベント値を保存
  @saveEventPageValue: (isRun = false) ->
    lstorage = localStorage
    h = PageValue.getEventPageValue(PageValue.Key.E_PREFIX)
    key = if isRun then @Key.RUN_EVENT_PAGEVALUES else @Key.WORKTABLE_EVENT_PAGEVALUES
    lstorage.setItem(key, JSON.stringify(h))
    # 現在時刻を保存
    key = if isRun then @Key.RUN_SAVETIME else @Key.WORKTABLE_SAVETIME
    lstorage.setItem(key, $.now())

  # ストレージからイベント値を読み込み
  @loadEventPageValue: (isRun = false) ->
    lstorage = localStorage
    key = if isRun then @Key.RUN_EVENT_PAGEVALUES else @Key.WORKTABLE_EVENT_PAGEVALUES
    h = JSON.parse(lstorage.getItem(key))
    for k, v of h
      PageValue.setEventPageValue(PageValue.Key.E_PREFIX + PageValue.Key.PAGE_VALUES_SEPERATOR + k, v)

  # ストレージに共通設定値を保存
  @saveSettingPageValue: (isRun = false) ->
    lstorage = localStorage
    h = PageValue.getSettingPageValue(Setting.PageValueKey.PREFIX)
    key = if isRun then @Key.RUN_SETTING_PAGEVALUES else @Key.WORKTABLE_SETTING_PAGEVALUES
    lstorage.setItem(key, JSON.stringify(h))
    # 現在時刻を保存
    key = if isRun then @Key.RUN_SAVETIME else @Key.WORKTABLE_SAVETIME
    lstorage.setItem(key, $.now())

  # ストレージから共通設定値を読み込み
  @loadSettingPageValue: (isRun = false) ->
    lstorage = localStorage
    key = if isRun then @Key.RUN_SETTING_PAGEVALUES else @Key.WORKTABLE_SETTING_PAGEVALUES
    h = JSON.parse(lstorage.getItem(key))
    for k, v of h
      PageValue.setSettingPageValue(Setting.PageValueKey.PREFIX + PageValue.Key.PAGE_VALUES_SEPERATOR + k, v)
