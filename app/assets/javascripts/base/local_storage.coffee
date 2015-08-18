class LocalStorage

  class @Key
    # @property [Int] WORKTABLE_EVENT_PAGEVALUES イベントページ値
    @WORKTABLE_EVENT_PAGEVALUES = 'worktable_event_pagevalues'
    # @property [Int] RUN_EVENT_PAGEVALUES イベントページ値
    @RUN_EVENT_PAGEVALUES = 'run_event_pagevalues'

  # @property [Int] SAVETIME_SUFFIX イベントページ値保存時の時間
  @SAVETIME_SUFFIX = '_time'
  # @property [Int] SAVETIME_LIMIT_MINUTES イベントページ値保存時間
  @SAVETIME_LIMIT_MINUTES = {}
  @SAVETIME_LIMIT_MINUTES[@Key.WORKTABLE_EVENT_PAGEVALUES] = 5

  constructor: (key) ->
    @lstorage = localStorage
    @storageKey = key

  # ストレージにページ値を保存
  saveEventPageValue: (saveTime = true) ->
    h = PageValue.getEventPageValue(PageValue.Key.E_PREFIX)
    @lstorage.setItem(@storageKey, JSON.stringify(h))
    if saveTime
      # 現在時刻を保存
      key = @storageKey + @constructor.SAVETIME_SUFFIX
      @lstorage.setItem(key, $.now())

  # ストレージからページ値を読み込み
  loadEventPageValue: ->
    h = JSON.parse(@lstorage.getItem(@storageKey))
    for k, v of h
      PageValue.setEventPageValue(PageValue.Key.E_PREFIX + PageValue.Key.PAGE_VALUES_SEPERATOR + k, v)

  # 保存時間が経過しているか
  isOverSaveTimeLimit: ->
    key = @storageKey + @constructor.SAVETIME_SUFFIX
    saveTime = @lstorage.getItem(key)
    if !saveTime?
      return true
    duration = $.now() - saveTime
    d = new Date(duration)
    m = d.getMinutes()
    return parseInt(m) > @constructor.SAVETIME_LIMIT_MINUTES[@storageKey]

  get: ->
    @lstorage.getItem(@storageKey)

  set: (value) ->
    @lstorage.setItem(@storageKey, value)

  clear: ->
    @lstorage.setItem(@storageKey, null)