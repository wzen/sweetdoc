class LocalStorage

  class @Key
    # @property [Int] WORKTABLE_EVENT_PAGEVALUES イベントページ値
    @WORKTABLE_EVENT_PAGEVALUES = 'worktable_event_pagevalues'
    # @property [Int] RUN_EVENT_PAGEVALUES イベントページ値
    @RUN_EVENT_PAGEVALUES = 'run_event_pagevalues'
    # @property [Int] TIME_SUFFIX イベントページ値保存時の時間
    @TIME_SUFFIX = '_time'

  constructor: (key) ->
    @lstorage = localStorage
    @storageKey = key

  # ストレージにページ値を保存
  saveEventPageValue: (saveTime = true) ->
    h = PageValue.getEventPageValue(PageValue.Key.E_PREFIX)
    @lstorage.setItem(@storageKey, JSON.stringify(h))
    if saveTime
      # 現在時刻を保存
      key = @storageKey + @TIME_SUFFIX
      @lstorage.setItem(key, $.now())

  # ストレージからページ値を読み込み
  loadEventPageValue: ->
    h = JSON.parse(@lstorage.getItem(@storageKey))
    PageValue.setEventPageValue(PageValue.Key.E_PREFIX, h)

  getSavedTime: ->
    key = @storageKey + @TIME_SUFFIX
    return @lstorage.getItem(key)

  get: ->
    @lstorage.getItem(@storageKey)

  set: (value) ->
    @lstorage.setItem(@storageKey, value)