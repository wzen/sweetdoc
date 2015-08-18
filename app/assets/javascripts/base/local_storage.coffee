class LocalStorage

  class @Key
    # @property [Int] WORKTABLE_EVENT_PAGEVALUES イベントページ値
    @WORKTABLE_EVENT_PAGEVALUES = 'worktable_event_pagevalues'
    # @property [Int] RUN_EVENT_PAGEVALUES イベントページ値
    @RUN_EVENT_PAGEVALUES = 'run_event_pagevalues'

  constructor: (key) ->
    @lstorage = localStorage
    @storageKey = key

  # ストレージにページ値を保存
  saveEventPageValue: ->
    h = PageValue.getEventPageValue(Constant.PageValueKey.E_PREFIX)
    @lstorage.setItem(@storageKey, JSON.stringify(h))

  # ストレージからページ値を読み込み
  loadEventPageValue: ->
    h = JSON.parse(@lstorage.getItem(@storageKey))
    PageValue.setEventPageValue(Constant.PageValueKey.E_PREFIX, h)

  get: ->
    @lstorage.getItem(@storageKey)

  set: (value) ->
    @lstorage.setItem(@storageKey, value)